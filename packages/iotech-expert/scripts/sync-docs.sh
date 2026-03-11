#!/usr/bin/env bash
# sync-docs.sh — 從 docs.iotechsys.com 下載 IOTech 文件並轉為 markdown
# 用法: bash sync-docs.sh [--dry-run] [--filter PATTERN] [--check-freshness]
#   --dry-run          只列出要下載的 URL，不實際下載
#   --filter           只下載檔名包含 PATTERN 的項目（例: --filter ec-ds-modbus）
#   --check-freshness  檢查距上次同步天數，回傳 JSON 格式結果後退出

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
REF_DIR="$SKILL_DIR/references"
URL_MAP="$REF_DIR/.url-map.json"
LAST_SYNC="$REF_DIR/.last-sync"
TEMP_DIR=$(mktemp -d)

# 清理暫存
trap 'rm -rf "$TEMP_DIR"' EXIT

# 參數解析
DRY_RUN=false
FILTER=""
CHECK_FRESHNESS=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        --filter) FILTER="$2"; shift 2 ;;
        --check-freshness) CHECK_FRESHNESS=true; shift ;;
        *) echo "未知參數: $1"; exit 1 ;;
    esac
done

# --check-freshness: 檢查距上次同步天數後退出
if $CHECK_FRESHNESS; then
    if [[ -f "$LAST_SYNC" ]]; then
        LAST_DATE=$(cat "$LAST_SYNC")
        LAST_EPOCH=$(date -jf '%Y-%m-%dT%H:%M:%SZ' "$LAST_DATE" '+%s' 2>/dev/null || date -d "$LAST_DATE" '+%s' 2>/dev/null || echo "")
        if [[ -z "$LAST_EPOCH" ]]; then
            echo "{\"last_sync\": \"$LAST_DATE\", \"days_ago\": null, \"stale\": true, \"error\": \"unable to parse date\"}"
            exit 0
        fi
        NOW_EPOCH=$(date '+%s')
        DAYS_AGO=$(( (NOW_EPOCH - LAST_EPOCH) / 86400 ))
        STALE=$( [ "$DAYS_AGO" -ge 14 ] && echo "true" || echo "false" )
        echo "{\"last_sync\": \"$LAST_DATE\", \"days_ago\": $DAYS_AGO, \"stale\": $STALE}"
    else
        echo "{\"last_sync\": null, \"days_ago\": null, \"stale\": true}"
    fi
    exit 0
fi

# 檢查相依工具
for cmd in curl pandoc; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "錯誤：需要 $cmd，請先安裝。"
        echo "  brew install $cmd"
        exit 1
    fi
done

# 讀取 URL 對應表
if [[ ! -f "$URL_MAP" ]]; then
    echo "錯誤：找不到 URL 對應表 $URL_MAP"
    exit 1
fi

echo "=== IOTech 文件同步 ==="
echo "參考目錄: $REF_DIR"
echo ""

# 用 python 解析 JSON（macOS 內建 python3）
ENTRIES=$(URL_MAP_PATH="$URL_MAP" python3 -c "
import json, os, sys
with open(os.environ['URL_MAP_PATH']) as f:
    data = json.load(f)
for entry in data['files']:
    print(f\"{entry['output']}|{','.join(entry['urls'])}\")
")

TOTAL=0
SUCCESS=0
SKIPPED=0
FAILED=0

while IFS='|' read -r OUTPUT URLS; do
    # 套用過濾器
    if [[ -n "$FILTER" && "$OUTPUT" != *"$FILTER"* ]]; then
        continue
    fi

    TOTAL=$((TOTAL + 1))
    OUTPUT_PATH="$REF_DIR/$OUTPUT"

    if $DRY_RUN; then
        echo "[DRY-RUN] $OUTPUT ← $URLS"
        continue
    fi

    echo "[$TOTAL] 正在同步: $OUTPUT"

    # 確保目錄存在
    mkdir -p "$(dirname "$OUTPUT_PATH")"

    # 合併多個 URL 的內容
    COMBINED=""
    IFS=',' read -ra URL_ARRAY <<< "$URLS"
    FETCH_OK=true

    for URL in "${URL_ARRAY[@]}"; do
        # 跨平台 hash（macOS 用 md5，Linux 用 md5sum）
        if command -v md5sum &>/dev/null; then
            URL_HASH=$(echo "$URL" | md5sum | cut -c1-8)
        else
            URL_HASH=$(echo "$URL" | md5 -q | cut -c1-8)
        fi
        TEMP_HTML="$TEMP_DIR/${URL_HASH}.html"
        TEMP_MD="$TEMP_DIR/${URL_HASH}.md"

        # 下載 HTML
        if ! curl -sL --max-time 30 "$URL" -o "$TEMP_HTML" 2>/dev/null; then
            echo "  警告：無法下載 $URL"
            FETCH_OK=false
            continue
        fi

        # 用 pandoc 轉換為 markdown
        if ! pandoc -f html -t gfm --wrap=none "$TEMP_HTML" -o "$TEMP_MD" 2>/dev/null; then
            echo "  警告：轉換失敗 $URL"
            FETCH_OK=false
            continue
        fi

        # 清理：移除導航元素、空行過多等
        CONTENT=$(TEMP_MD_PATH="$TEMP_MD" python3 -c "
import re, os, sys
with open(os.environ['TEMP_MD_PATH']) as f:
    text = f.read()
# 移除連續空行（保留最多兩個）
text = re.sub(r'\n{4,}', '\n\n\n', text)
# 移除常見的導航文字
text = re.sub(r'(?m)^(Previous|Next|Table of Contents|Skip to content).*$', '', text)
# 移除空的連結
text = re.sub(r'\[([^\]]*)\]\(\s*\)', r'\1', text)
print(text.strip())
")

        if [[ -n "$COMBINED" ]]; then
            COMBINED="$COMBINED"$'\n\n---\n\n'"$CONTENT"
        else
            COMBINED="$CONTENT"
        fi
    done

    if [[ -n "$COMBINED" ]]; then
        # 加上來源標頭（統一格式）
        {
            echo "<!--"
            echo "  Source URLs:"
            for _url in "${URL_ARRAY[@]}"; do
                echo "    - $_url"
            done
            echo "  Synced: $(date -u '+%Y-%m-%d')"
            echo "-->"
            echo ""
            echo "$COMBINED"
        } > "$OUTPUT_PATH"
        SUCCESS=$((SUCCESS + 1))
        echo "  完成 ✓"
    else
        echo "  失敗 ✗ (所有 URL 都無法取得)"
        FAILED=$((FAILED + 1))
    fi
done <<< "$ENTRIES"

# 更新時間戳
if ! $DRY_RUN; then
    date -u '+%Y-%m-%dT%H:%M:%SZ' > "$LAST_SYNC"
    echo ""
    echo "=== 同步完成 ==="
    echo "成功: $SUCCESS / $TOTAL"
    [[ $FAILED -gt 0 ]] && echo "失敗: $FAILED"
    echo "時間戳已更新: $(cat "$LAST_SYNC")"

    # 版本偵測：檢查線上文件是否出現新版本號
    echo ""
    echo "=== 版本檢查 ==="
    VERSION_CHANGES=$(URL_MAP_PATH="$URL_MAP" REF_DIR_PATH="$REF_DIR" python3 -c "
import json, os, re

url_map_path = os.environ['URL_MAP_PATH']
ref_dir = os.environ['REF_DIR_PATH']

with open(url_map_path) as f:
    data = json.load(f)

known = data.get('product_versions', {})
warnings = []

# Scan synced files for version patterns
for fname in os.listdir(ref_dir):
    if not fname.endswith('.md'):
        continue
    fpath = os.path.join(ref_dir, fname)
    with open(fpath) as f:
        content = f.read()[:2000]  # Only check top of file

    # Look for Edge Central version patterns
    for m in re.finditer(r'Edge Central\s+(\d+\.\d+)', content):
        found = m.group(1)
        if found != known.get('edge_central', ''):
            warnings.append(f'Edge Central: {known.get(\"edge_central\",\"?\")} -> {found}')

    for m in re.finditer(r'Edge Manager\s+(\d+\.\d+)', content):
        found = m.group(1)
        if found != known.get('edge_manager', ''):
            warnings.append(f'Edge Manager: {known.get(\"edge_manager\",\"?\")} -> {found}')

if warnings:
    seen = set()
    for w in warnings:
        if w not in seen:
            print(w)
            seen.add(w)
else:
    print('OK')
" 2>/dev/null)

    if [[ "$VERSION_CHANGES" != "OK" && -n "$VERSION_CHANGES" ]]; then
        echo "⚠ 偵測到版本變更："
        echo "$VERSION_CHANGES"
        echo "請更新 .url-map.json 中的 product_versions 並檢查 URL 是否需要調整。"
    else
        echo "版本一致，無變更。"
    fi
else
    echo ""
    echo "=== DRY-RUN 完成，共 $TOTAL 個檔案 ==="
fi

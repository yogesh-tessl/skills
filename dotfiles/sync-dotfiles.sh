#!/bin/bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MANIFEST="$SCRIPT_DIR/manifest.yaml"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

HOST=""
DRY_RUN=false
WITH_PACKAGES=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)    DRY_RUN=true; shift ;;
        --with-packages) WITH_PACKAGES=true; shift ;;
        -*)           echo "未知選項: $1"; exit 1 ;;
        *)            HOST="$1"; shift ;;
    esac
done

if [[ -z "$HOST" ]]; then
    echo "用法: sync-dotfiles.sh <host> [--dry-run] [--with-packages]"
    exit 1
fi

for cmd in yq python3; do
    if ! command -v "$cmd" &>/dev/null; then
        echo -e "${RED}❌ 需要 $cmd 但未安裝${NC}"
        exit 1
    fi
done

if [[ ! -f "$MANIFEST" ]]; then
    echo -e "${RED}❌ 找不到 $MANIFEST${NC}"
    exit 1
fi

expand_local() { echo "${1/#\~/$HOME}"; }
expand_remote() { echo "${1/#\~/\$HOME}"; }

COPY_OK=0; COPY_FAIL=0
RSYNC_OK=0; RSYNC_FAIL=0
MERGE_OK=0; MERGE_FAIL=0
FAILED=()
BACKUP_DIR=""

log_info()  { echo -e "${CYAN}  $1${NC}"; }
log_ok()    { echo -e "${GREEN}  ✅ $1${NC}"; }
log_warn()  { echo -e "${YELLOW}  ⚠️  $1${NC}"; }
log_fail()  { echo -e "${RED}  ❌ $1${NC}"; }

echo ""
echo "══════════════════════════════════════"
echo "  Dotfiles 同步 → $HOST"
if $DRY_RUN; then echo "  （dry-run 模式，不實際寫入）"; fi
echo "══════════════════════════════════════"
echo ""

# ── SSH 連線驗證（dry-run 也執行）──
echo "🔗 驗證 SSH 連線..."
if ! ssh -o ConnectTimeout=5 "$HOST" "echo ok" &>/dev/null; then
    log_fail "無法連線到 $HOST"
    exit 1
fi
log_ok "SSH 連線正常"
echo ""

# ── 自動備份遠端 ──
BACKUP_DIR="shell-backup-$(date +%Y%m%d-%H%M%S)"

if ! $DRY_RUN; then
    echo "📦 備份遠端設定..."

    BACKUP_FILES=()
    while IFS= read -r p; do
        [[ -n "$p" ]] && BACKUP_FILES+=("$p")
    done < <(yq '.copy[]' "$MANIFEST" 2>/dev/null)
    while IFS= read -r p; do
        [[ -n "$p" ]] && BACKUP_FILES+=("$p")
    done < <(yq '.copy_verify_ssh[]' "$MANIFEST" 2>/dev/null)
    while IFS= read -r p; do
        [[ -n "$p" ]] && BACKUP_FILES+=("$p")
    done < <(yq '.merge_json[]' "$MANIFEST" 2>/dev/null)

    ssh "$HOST" "mkdir -p \$HOME/$BACKUP_DIR"
    for f in "${BACKUP_FILES[@]}"; do
        remote_f="$(expand_remote "$f")"
        ssh "$HOST" "if [ -f \"$remote_f\" ]; then mkdir -p \"\$HOME/$BACKUP_DIR/\$(dirname \"${f#\~/}\")\" && cp \"$remote_f\" \"\$HOME/$BACKUP_DIR/${f#\~/}\" 2>/dev/null; fi" || true
    done
    log_ok "已備份到 ~/$BACKUP_DIR/"
    echo ""
else
    log_info "[dry-run] 將備份到 ~/$BACKUP_DIR/"
    echo ""
fi

# ── 執行 copy 區塊 ──
echo "📄 同步設定檔（copy）..."
while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    local_path="$(expand_local "$path")"

    if [[ ! -f "$local_path" ]]; then
        log_warn "$path 本機不存在，跳過"
        FAILED+=("$path（本機不存在）")
        COPY_FAIL=$((COPY_FAIL + 1))
        continue
    fi

    if $DRY_RUN; then
        log_info "[dry-run] $path"
        COPY_OK=$((COPY_OK + 1))
        continue
    fi

    remote_path="$(expand_remote "$path")"
    remote_dir="$(dirname "$remote_path")"
    ssh "$HOST" "mkdir -p \"$remote_dir\"" 2>/dev/null

    if scp -q "$local_path" "$HOST:$remote_path" 2>/dev/null; then
        log_ok "$path"
        COPY_OK=$((COPY_OK + 1))
    else
        log_fail "$path"
        FAILED+=("$path（scp 失敗）")
        COPY_FAIL=$((COPY_FAIL + 1))
    fi
done < <(yq '.copy[]' "$MANIFEST" 2>/dev/null)
echo ""

# ── 執行 copy_verify_ssh 區塊（高風險：推送後驗證語法）──
echo "🔐 同步 SSH 設定（推送後驗證）..."
while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    local_path="$(expand_local "$path")"

    if [[ ! -f "$local_path" ]]; then
        log_warn "$path 本機不存在，跳過"
        FAILED+=("$path（本機不存在）")
        COPY_FAIL=$((COPY_FAIL + 1))
        continue
    fi

    if $DRY_RUN; then
        log_info "[dry-run] $path（推送後將驗證語法）"
        COPY_OK=$((COPY_OK + 1))
        continue
    fi

    remote_path="$(expand_remote "$path")"
    remote_dir="$(dirname "$remote_path")"
    ssh "$HOST" "mkdir -p \"$remote_dir\"" 2>/dev/null
    scp -q "$local_path" "$HOST:$remote_path" 2>/dev/null

    if ssh "$HOST" "ssh -G localhost &>/dev/null" 2>/dev/null; then
        log_ok "$path（語法驗證通過）"
        COPY_OK=$((COPY_OK + 1))
    else
        log_fail "$path — SSH config 語法錯誤！正在從備份還原..."
        ssh "$HOST" "cp \$HOME/$BACKUP_DIR/${path#\~/} \"$remote_path\" 2>/dev/null" || true
        FAILED+=("$path（語法驗證失敗，已還原）")
        COPY_FAIL=$((COPY_FAIL + 1))
    fi
done < <(yq '.copy_verify_ssh[]' "$MANIFEST" 2>/dev/null)
echo ""

# ── 執行 rsync 區塊 ──
echo "📂 同步目錄（rsync）..."
while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    local_path="$(expand_local "$path")"

    if [[ ! -d "$local_path" ]]; then
        log_warn "$path 本機不存在，跳過"
        FAILED+=("$path（目錄不存在）")
        RSYNC_FAIL=$((RSYNC_FAIL + 1))
        continue
    fi

    if $DRY_RUN; then
        log_info "[dry-run] $path"
        RSYNC_OK=$((RSYNC_OK + 1))
        continue
    fi

    remote_path="$(expand_remote "$path")"
    ssh "$HOST" "mkdir -p \"$remote_path\"" 2>/dev/null

    if rsync -av --quiet "$local_path" "$HOST:$path" 2>/dev/null; then
        log_ok "$path"
        RSYNC_OK=$((RSYNC_OK + 1))
    else
        log_fail "$path"
        FAILED+=("$path（rsync 失敗）")
        RSYNC_FAIL=$((RSYNC_FAIL + 1))
    fi
done < <(yq '.rsync[]' "$MANIFEST" 2>/dev/null)
echo ""

# ── 執行 merge_json 區塊 ──
echo "🔀 合併 JSON..."
while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    local_path="$(expand_local "$path")"

    if [[ ! -f "$local_path" ]]; then
        log_warn "$path 本機不存在，跳過"
        FAILED+=("$path（本機不存在）")
        MERGE_FAIL=$((MERGE_FAIL + 1))
        continue
    fi

    if $DRY_RUN; then
        log_info "[dry-run] $path（合併主力機 ∪ 遠端獨有）"
        MERGE_OK=$((MERGE_OK + 1))
        continue
    fi

    remote_path="$(expand_remote "$path")"
    TMP_REMOTE="/tmp/dotfiles-merge-remote-$$.json"
    TMP_MERGED="/tmp/dotfiles-merge-result-$$.json"

    scp -q "$HOST:$remote_path" "$TMP_REMOTE" 2>/dev/null || true

    python3 -c "
import json, sys
primary = json.load(open(sys.argv[1]))
try:
    remote = json.load(open(sys.argv[2]))
except (FileNotFoundError, json.JSONDecodeError):
    json.dump(primary, open(sys.argv[3], 'w'), indent=2)
    sys.exit(0)
merged = dict(primary)
for key, value in remote.get('plugins', {}).items():
    if key not in merged.get('plugins', {}):
        merged.setdefault('plugins', {})[key] = value
json.dump(merged, open(sys.argv[3], 'w'), indent=2)
" "$local_path" "$TMP_REMOTE" "$TMP_MERGED" 2>/dev/null

    if [[ -f "$TMP_MERGED" ]]; then
        remote_dir="$(dirname "$remote_path")"
        ssh "$HOST" "mkdir -p \"$remote_dir\"" 2>/dev/null
        scp -q "$TMP_MERGED" "$HOST:$remote_path" 2>/dev/null
        log_ok "$path"
        MERGE_OK=$((MERGE_OK + 1))
    else
        log_warn "$path 合併失敗，改用主力機版本覆寫"
        scp -q "$local_path" "$HOST:$remote_path" 2>/dev/null
        MERGE_OK=$((MERGE_OK + 1))
    fi

    rm -f "$TMP_REMOTE" "$TMP_MERGED"
done < <(yq '.merge_json[]' "$MANIFEST" 2>/dev/null)
echo ""

# ── 執行 packages 區塊（--with-packages）──
if $WITH_PACKAGES; then
    echo "📦 補裝缺少的套件..."

    FORMULAS=$(yq '.packages.brew_formula[]' "$MANIFEST" 2>/dev/null | tr '\n' ' ')
    if [[ -n "$FORMULAS" ]]; then
        if $DRY_RUN; then
            log_info "[dry-run] brew install $FORMULAS"
        else
            log_info "brew formula: $FORMULAS"
            ssh "$HOST" "/opt/homebrew/bin/brew install $FORMULAS 2>&1 | tail -5" || true
        fi
    fi

    CASKS=$(yq '.packages.brew_cask[]' "$MANIFEST" 2>/dev/null | tr '\n' ' ')
    if [[ -n "$CASKS" ]]; then
        if $DRY_RUN; then
            log_info "[dry-run] brew install --cask $CASKS"
        else
            log_info "brew cask: $CASKS"
            ssh "$HOST" "/opt/homebrew/bin/brew install --cask $CASKS 2>&1 | tail -5" || true
        fi
    fi

    NPM_PKGS=$(yq '.packages.npm_global[]' "$MANIFEST" 2>/dev/null | tr '\n' ' ')
    if [[ -n "$NPM_PKGS" ]]; then
        if $DRY_RUN; then
            log_info "[dry-run] npm install -g $NPM_PKGS"
        else
            log_info "npm global: $NPM_PKGS"
            ssh "$HOST" "source ~/.nvm/nvm.sh && npm install -g $NPM_PKGS 2>&1 | tail -5" || true
        fi
    fi
    echo ""
fi

# ── 摘要報告 ──
TOTAL_OK=$((COPY_OK + RSYNC_OK + MERGE_OK))
TOTAL_FAIL=${#FAILED[@]}

echo "══════════════════════════════════════"
if [[ $TOTAL_FAIL -eq 0 ]]; then
    echo -e "  ${GREEN}Dotfiles 同步完成 → $HOST${NC}"
else
    echo -e "  ${YELLOW}Dotfiles 同步完成 → $HOST（有錯誤）${NC}"
fi
echo "══════════════════════════════════════"
echo "  複製：  $COPY_OK 個檔案$([ $COPY_FAIL -gt 0 ] && echo "（$COPY_FAIL 失敗）" || echo " ✅")"
echo "  rsync： $RSYNC_OK 個目錄$([ $RSYNC_FAIL -gt 0 ] && echo "（$RSYNC_FAIL 失敗）" || echo " ✅")"
echo "  合併：  $MERGE_OK 個 JSON$([ $MERGE_FAIL -gt 0 ] && echo "（$MERGE_FAIL 失敗）" || echo " ✅")"
if [[ -n "$BACKUP_DIR" ]] && ! $DRY_RUN; then
    echo "  備份：  ~/$BACKUP_DIR/"
fi

if [[ $TOTAL_FAIL -gt 0 ]]; then
    echo ""
    echo -e "  ${YELLOW}⚠️  失敗項目：${NC}"
    for f in "${FAILED[@]}"; do
        echo "    - $f"
    done
fi
echo "══════════════════════════════════════"
echo ""

[[ $TOTAL_FAIL -gt 0 ]] && exit 1 || exit 0

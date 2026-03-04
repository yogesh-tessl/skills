#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGES_DIR="$SCRIPT_DIR/packages"
STAGING_DIR=$(mktemp -d)

# ────────────────────────────────────────────────
# add.sh — 從 npx skills 安裝 skill 並納入集中管理
#
# 使用方式（與 npx skills add 完全相容）：
#   ./add.sh vercel-labs/agent-skills
#   ./add.sh https://github.com/author/repo
#   ./add.sh author/repo --skill pr-review commit
#   ./add.sh author/repo --all
#
# 流程：npx skills add → 搬進 packages/ → sync.sh
# ────────────────────────────────────────────────

cleanup() {
    rm -rf "$STAGING_DIR"
}
trap cleanup EXIT

if [ $# -eq 0 ]; then
    echo "使用方式：./add.sh <package> [npx skills add 的任何參數]"
    echo ""
    echo "範例："
    echo "  ./add.sh vercel-labs/agent-skills"
    echo "  ./add.sh https://github.com/author/repo"
    echo "  ./add.sh author/repo --skill pr-review commit"
    echo "  ./add.sh author/repo --all"
    echo "  ./add.sh author/repo --skill cool-skill -y"
    exit 1
fi

# ── 1. 記錄安裝前 packages/ 已有的 skill ──
BEFORE=$(ls "$PACKAGES_DIR" 2>/dev/null | sort)

# ── 2. 透過 npx skills add 安裝到暫存目錄 ──
#    使用 --copy 確保拿到實體檔案（非 symlink）
#    指定 --agent claude-code 只產出一份，避免重複
echo "📥 透過 npx skills 安裝..."
echo ""

# 建立暫存的 agent 目錄結構
mkdir -p "$STAGING_DIR/.claude/skills"

# 用 HOME 覆寫讓 npx skills 安裝到暫存目錄
HOME="$STAGING_DIR" npx skills add "$@" -g --copy --agent claude-code -y 2>&1 || true

# ── 3. 找出新安裝的 skill 並搬進 packages/ ──
INSTALLED_SKILLS=$(find "$STAGING_DIR/.claude/skills" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; 2>/dev/null | sort)

if [ -z "$INSTALLED_SKILLS" ]; then
    # 有些 agent 可能用不同路徑，搜尋所有可能位置
    INSTALLED_SKILLS=$(find "$STAGING_DIR" -name "SKILL.md" -maxdepth 4 2>/dev/null \
        | xargs -I{} dirname {} \
        | xargs -I{} basename {} \
        | sort -u)
fi

if [ -z "$INSTALLED_SKILLS" ]; then
    echo ""
    echo "❌ 未偵測到新安裝的 skill，請檢查套件名稱是否正確"
    exit 1
fi

echo ""
NEW_COUNT=0
for SKILL in $INSTALLED_SKILLS; do
    SOURCE="$STAGING_DIR/.claude/skills/$SKILL"
    TARGET="$PACKAGES_DIR/$SKILL"

    if [ ! -d "$SOURCE" ]; then
        continue
    fi

    if [ -d "$TARGET" ]; then
        echo "⚠️  $SKILL 已存在於 packages/，跳過（如需更新請手動處理）"
    else
        mv "$SOURCE" "$TARGET"
        echo "✅ $SKILL → packages/$SKILL"
        NEW_COUNT=$((NEW_COUNT + 1))
    fi
done

if [ "$NEW_COUNT" -eq 0 ]; then
    echo ""
    echo "ℹ️  沒有新的 skill 需要加入"
    exit 0
fi

# ── 4. 同步到 git 並分發到所有 Agent ──
echo ""
echo "🔄 開始同步..."
"$SCRIPT_DIR/sync.sh"

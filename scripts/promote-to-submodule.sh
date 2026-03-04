#!/bin/bash
set -euo pipefail

# ────────────────────────────────────────────────
# 將 packages/ 下的 skill 獨立發佈為 Git Submodule
#
# 用法：
#   ./scripts/promote-to-submodule.sh <skill-name> [github-repo-url]
#
# 範例：
#   ./scripts/promote-to-submodule.sh crisp-reading
#   ./scripts/promote-to-submodule.sh crisp-reading git@github.com:kcchien/crisp-reading.git
#
# 若未提供 repo URL，自動用 gh CLI 建立新的公開 repo
# ────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR"

SKILL="${1:-}"
REPO_URL="${2:-}"
SKILL_DIR="packages/$SKILL"

# ── 驗證 ──
if [ -z "$SKILL" ]; then
    echo "用法：$0 <skill-name> [github-repo-url]"
    exit 1
fi

if [ ! -d "$SKILL_DIR" ]; then
    echo "❌ $SKILL_DIR 不存在"
    exit 1
fi

if [ -f "$SKILL_DIR/.git" ]; then
    echo "❌ $SKILL 已經是 submodule"
    exit 1
fi

# ── 1. 若沒給 repo URL，用 gh CLI 建立 ──
if [ -z "$REPO_URL" ]; then
    if ! command -v gh &>/dev/null; then
        echo "❌ 未提供 repo URL 且 gh CLI 未安裝，無法自動建立 repo"
        exit 1
    fi
    echo "📦 建立 GitHub repo: kcchien/$SKILL ..."
    gh repo create "kcchien/$SKILL" --public --confirm
    REPO_URL="git@github.com:kcchien/$SKILL.git"
fi

echo "🔄 開始將 $SKILL 獨立化..."

# ── 2. 從 parent repo 移除追蹤（保留檔案） ──
git rm -r --cached "$SKILL_DIR"

# ── 3. 在 skill 目錄初始化 git 並推送 ──
cd "$SKILL_DIR"
git init
git add .
git commit -m "feat: initial commit for $SKILL skill"
git remote add origin "$REPO_URL"
git branch -M main
git push -u origin main
cd "$ROOT_DIR"

# ── 4. 移除臨時 .git 目錄，改用 submodule ──
rm -rf "$SKILL_DIR/.git"
git submodule add "$REPO_URL" "$SKILL_DIR"
git commit -m "refactor: promote $SKILL to independent submodule"

echo ""
echo "✅ $SKILL 已獨立發佈至 $REPO_URL"
echo "   - parent repo 已更新 .gitmodules"
echo "   - 可在 packages/$SKILL/ 內獨立開發與推送"

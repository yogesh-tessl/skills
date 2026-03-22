#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# ────────────────────────────────────────────────
# sync.sh — 一鍵同步 git ↔ skills ↔ agents
#
# 使用方式：
#   ./sync.sh              # 完整同步（提交 + 拉 + 推 + 分發）
#   ./sync.sh --pull       # 只拉取遠端，不推送本地變更
#   ./sync.sh --local      # 只分發到本機 Agent，不碰 git
#   ./sync.sh --dotfiles <host>              # 同步設定檔到遠端
#   ./sync.sh --dotfiles <host> --dry-run    # 預覽不執行
#   ./sync.sh --dotfiles <host> --with-packages  # 含套件補裝
# ────────────────────────────────────────────────

# ── Dotfiles 同步模式（獨立於 skills 同步）──
if [ "${1:-}" = "--dotfiles" ]; then
    shift
    exec "$SCRIPT_DIR/dotfiles/sync-dotfiles.sh" "$@"
fi

MODE="full"
if [ "${1:-}" = "--pull" ]; then
    MODE="pull"
elif [ "${1:-}" = "--local" ]; then
    MODE="local"
fi

# ── 1. 先提交本地變更（僅 full 模式）──
#    先提交再拉取，避免 autostash 在複雜狀態下失敗
if [ "$MODE" = "full" ]; then
    CHANGES=$(git status --porcelain --ignore-submodules=dirty 2>/dev/null || true)

    if [ -n "$CHANGES" ]; then
        echo "📦 偵測到本地變更："
        echo "$CHANGES" | while IFS= read -r line; do
            echo "   $line"
        done
        echo ""

        # 收集新增/異動的 skill 名稱作為 commit message
        SKILL_NAMES=$(echo "$CHANGES" \
            | grep -oE 'packages/[^/]+' \
            | sed 's|packages/||' \
            | sort -u \
            | tr '\n' ', ' \
            | sed 's/,$//' || true)

        if [ -n "$SKILL_NAMES" ]; then
            MSG="sync: update skills — $SKILL_NAMES"
        else
            MSG="sync: update skill config"
        fi

        # 確保所有 .sh 保持可執行，防止編輯器或同步工具意外移除 execute bit
        find "$SCRIPT_DIR" -name '*.sh' ! -perm -u+x -exec chmod +x {} +

        git add -A
        # 還原 submodule 的 staging，避免誤提交 submodule 狀態變更
        if [ -f .gitmodules ]; then
            git config --file .gitmodules --get-regexp path \
                | awk '{print $2}' \
                | while read -r sm_path; do
                    git reset HEAD -- "$sm_path" 2>/dev/null || true
                done
        fi
        git commit -m "$MSG" || true
        echo ""
    else
        echo "✅ 本地無變更"
        echo ""
    fi
fi

# ── 2. 拉取遠端（--local 跳過）──
if [ "$MODE" != "local" ]; then
    echo "⬇️  拉取遠端變更..."
    git pull --rebase
    git submodule update --init --recursive
    echo ""
fi

# ── 3. 推送到遠端（僅 full 模式，且有東西可推）──
if [ "$MODE" = "full" ]; then
    LOCAL=$(git rev-parse HEAD 2>/dev/null)
    REMOTE=$(git rev-parse @{u} 2>/dev/null || echo "")

    if [ "$LOCAL" != "$REMOTE" ]; then
        echo "⬆️  推送到遠端..."
        git push
        echo ""
    fi
fi

# ── 4. 分發 skill 到本機各 Agent ──
echo "🔗 分發 skill 到本機 Agent..."
"$SCRIPT_DIR/install.sh"

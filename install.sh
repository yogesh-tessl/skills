#!/bin/bash

# 自動偵測 repo 根目錄，指向 packages/ 子資料夾
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/packages"

# Agent 名稱與 global skills 路徑（對齊 npx skills -g 的預設路徑）
AGENTS=(
    # 主流 Agent
    "Claude Code|$HOME/.claude/skills"
    "Cursor|$HOME/.cursor/skills"
    "Windsurf IDE|$HOME/.codeium/windsurf/skills"
    "GitHub Copilot|$HOME/.copilot/skills"
    "OpenAI Codex|$HOME/.codex/skills"
    "Gemini CLI|$HOME/.gemini/skills"
    "Google Antigravity|$HOME/.gemini/antigravity/skills"
    "Cline|$HOME/.cline/skills"
    "Roo Code|$HOME/.roo/skills"
    "Continue|$HOME/.continue/skills"
    "Augment|$HOME/.augment/skills"
    "Goose|$HOME/.config/goose/skills"
    "Kiro CLI|$HOME/.kiro/skills"
    "OpenCode|$HOME/.config/opencode/skills"
    "OpenHands|$HOME/.openhands/skills"
    "Trae|$HOME/.trae/skills"
    "Junie|$HOME/.junie/skills"
    "Amp|$HOME/.config/agents/skills"
    "Agents (fallback)|$HOME/.agents/skills"
)

echo "🚀 開始設定 AI Skills 同步..."

for ENTRY in "${AGENTS[@]}"; do
    AGENT="${ENTRY%%|*}"
    TARGET="${ENTRY##*|}"
    PARENT_DIR=$(dirname "$TARGET")

    # 1. 確保父目錄存在
    if [ ! -d "$PARENT_DIR" ]; then
        echo "   創建父目錄: $PARENT_DIR"
        mkdir -p "$PARENT_DIR"
    fi

    # 2. 處理舊的 Skills 資料夾
    if [ -d "$TARGET" ] && [ ! -L "$TARGET" ]; then
        echo "⚠️  發現既有實體資料夾 ($AGENT)，正在備份為 .bak..."
        mv "$TARGET" "${TARGET}.bak_$(date +%s)"
    elif [ -L "$TARGET" ]; then
        # 如果已經是連結，先移除以便更新
        rm "$TARGET"
    fi

    # 3. 建立符號連結
    ln -s "$SOURCE_DIR" "$TARGET"
    echo "✅ $AGENT 同步完成 -> 指向 $SOURCE_DIR"
done

echo "🎉 所有 Agent 設定完畢！請重新啟動您的終端機或編輯器。"

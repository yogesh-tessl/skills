#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/packages"
CONFIG="$SCRIPT_DIR/agents.yaml"

# ── 檢查必要工具 ──
if ! command -v yq &>/dev/null; then
    echo "❌ 需要 yq 來解析 agents.yaml。請先執行 ./bootstrap.sh 或 brew install yq"
    exit 1
fi

# ── 完整的 Agent Registry（來源：vercel-labs/skills agents.ts）──
# 格式：agent-id|display-name|global-skills-path
AGENT_REGISTRY=(
    "claude-code|Claude Code|$HOME/.claude/skills"
    "cursor|Cursor|$HOME/.cursor/skills"
    "windsurf|Windsurf|$HOME/.codeium/windsurf/skills"
    "github-copilot|GitHub Copilot|$HOME/.copilot/skills"
    "codex|Codex|$HOME/.codex/skills"
    "gemini-cli|Gemini CLI|$HOME/.gemini/skills"
    "antigravity|Antigravity|$HOME/.gemini/antigravity/skills"
    "cline|Cline|$HOME/.cline/skills"
    "roo|Roo Code|$HOME/.roo/skills"
    "continue|Continue|$HOME/.continue/skills"
    "augment|Augment|$HOME/.augment/skills"
    "goose|Goose|$HOME/.config/goose/skills"
    "kiro-cli|Kiro CLI|$HOME/.kiro/skills"
    "opencode|OpenCode|$HOME/.config/opencode/skills"
    "openhands|OpenHands|$HOME/.openhands/skills"
    "trae|Trae|$HOME/.trae/skills"
    "trae-cn|Trae CN|$HOME/.trae-cn/skills"
    "junie|Junie|$HOME/.junie/skills"
    "amp|Amp|$HOME/.config/agents/skills"
    "codebuddy|CodeBuddy|$HOME/.codebuddy/skills"
    "command-code|Command Code|$HOME/.commandcode/skills"
    "cortex|Cortex Code|$HOME/.snowflake/cortex/skills"
    "crush|Crush|$HOME/.config/crush/skills"
    "droid|Droid|$HOME/.factory/skills"
    "iflow-cli|iFlow CLI|$HOME/.iflow/skills"
    "kilo|Kilo Code|$HOME/.kilocode/skills"
    "kode|Kode|$HOME/.kode/skills"
    "mcpjam|MCPJam|$HOME/.mcpjam/skills"
    "mistral-vibe|Mistral Vibe|$HOME/.vibe/skills"
    "mux|Mux|$HOME/.mux/skills"
    "openclaw|OpenClaw|$HOME/.openclaw/skills"
    "pi|Pi|$HOME/.pi/agent/skills"
    "qoder|Qoder|$HOME/.qoder/skills"
    "qwen-code|Qwen Code|$HOME/.qwen/skills"
    "replit|Replit|$HOME/.config/agents/skills"
    "zencoder|Zencoder|$HOME/.zencoder/skills"
    "neovate|Neovate|$HOME/.neovate/skills"
    "pochi|Pochi|$HOME/.pochi/skills"
    "adal|AdaL|$HOME/.adal/skills"
)

# ── 解析 agents.yaml：展開群組繼承，回傳 skill 清單 ──
resolve_group() {
    local group_name="$1"

    # 檢查群組是否使用 inherit 結構（像 full 群組）
    local has_inherit
    has_inherit=$(yq ".groups.${group_name} | has(\"inherit\")" "$CONFIG" 2>/dev/null)

    if [ "$has_inherit" = "true" ]; then
        # 有繼承：先展開所有繼承的群組
        local inherited_groups
        inherited_groups=$(yq ".groups.${group_name}.inherit[]" "$CONFIG" 2>/dev/null)
        for parent in $inherited_groups; do
            resolve_group "$parent"
        done
        # 再加上自己的 extra skill
        yq ".groups.${group_name}.extra[]" "$CONFIG" 2>/dev/null || true
    else
        # 簡單列表群組
        yq ".groups.${group_name}[]" "$CONFIG" 2>/dev/null
    fi
}

# 取得某個 Agent 應安裝的 skill 清單
resolve_skills() {
    local agent_id="$1"
    local assignment

    # 從 agents.yaml 查詢該 agent 的群組指定
    local has_agent
    has_agent=$(yq ".agents | has(\"${agent_id}\")" "$CONFIG" 2>/dev/null)

    local skills=""

    # 檢查是否為「全部同步」語法（"*"、all、null/空）
    local value=""
    if [ "$has_agent" = "true" ]; then
        value=$(yq ".agents.\"${agent_id}\"" "$CONFIG" 2>/dev/null)
    fi

    if [ "$value" = "*" ] || [ "$value" = "all" ] || [ "$value" = "null" ] || [ -z "$value" ]; then
        # 動態掃描 packages/ 下所有子目錄（排除隱藏目錄）
        local all_skills
        all_skills=$(find "$SOURCE_DIR" -maxdepth 1 -mindepth 1 -type d -not -name ".*" -exec basename {} \; | sort | tr '\n' ' ')
        echo "$all_skills"
        return
    fi

    local is_array

    if [ "$has_agent" = "true" ]; then
        is_array=$(yq ".agents.\"${agent_id}\" | tag" "$CONFIG" 2>/dev/null)
    else
        is_array="!!str"
    fi

    if [ "$is_array" = "!!seq" ]; then
        # 陣列：逐一展開每個群組
        local groups
        groups=$(yq ".agents.\"${agent_id}\"[]" "$CONFIG" 2>/dev/null)
        for group in $groups; do
            skills="$skills $(resolve_group "$group")"
        done
    else
        # 單一群組名
        local group_name
        if [ "$has_agent" = "true" ]; then
            group_name=$(yq ".agents.\"${agent_id}\"" "$CONFIG" 2>/dev/null)
        else
            group_name=$(yq ".agents._default" "$CONFIG" 2>/dev/null)
        fi
        skills=$(resolve_group "$group_name")
    fi

    # 去重並輸出
    echo "$skills" | tr ' ' '\n' | grep -v '^$' | sort -u | tr '\n' ' '
}

# ── 主邏輯 ──
echo "🚀 開始設定 AI Skills 同步..."
echo ""

INSTALLED_COUNT=0
SKIPPED_COUNT=0

for ENTRY in "${AGENT_REGISTRY[@]}"; do
    AGENT_ID="${ENTRY%%|*}"
    REST="${ENTRY#*|}"
    AGENT_NAME="${REST%%|*}"
    TARGET="${REST#*|}"
    PARENT_DIR=$(dirname "$TARGET")

    # 1. 偵測：Agent 是否已安裝（父目錄存在）
    if [ ! -d "$PARENT_DIR" ]; then
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
        continue
    fi

    # 2. 查詢該 Agent 的 skill 清單
    SKILLS=$(resolve_skills "$AGENT_ID")

    if [ -z "$SKILLS" ]; then
        echo "⚠️  $AGENT_NAME: 無法解析 skill 清單，跳過"
        continue
    fi

    # 3. 處理舊的整目錄 symlink（從舊架構遷移）
    if [ -L "$TARGET" ]; then
        rm "$TARGET"
        mkdir -p "$TARGET"
        echo "🔄 $AGENT_NAME: 從整目錄 symlink 遷移為逐個 symlink"
    elif [ ! -d "$TARGET" ]; then
        mkdir -p "$TARGET"
    fi

    # 4. 清除 target 下由本工具建立的舊 symlink（只清 symlink，保留實體目錄）
    find "$TARGET" -maxdepth 1 -type l -delete

    # 5. 建立逐個 skill 的 symlink
    SKILL_COUNT=0
    for SKILL in $SKILLS; do
        if [ -d "$SOURCE_DIR/$SKILL" ]; then
            ln -s "$SOURCE_DIR/$SKILL" "$TARGET/$SKILL"
            SKILL_COUNT=$((SKILL_COUNT + 1))
        fi
    done

    INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
    echo "✅ $AGENT_NAME: $SKILL_COUNT skills 同步完成"
done

echo ""
echo "🎉 完成！已處理 $INSTALLED_COUNT 個 Agent（跳過 $SKIPPED_COUNT 個未安裝的）"

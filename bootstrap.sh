#!/bin/bash
set -euo pipefail

# ────────────────────────────────────────────────
# 新機器一鍵設定
#
# 使用方式：
#   git clone git@github.com:kcchien/skills.git ~/Downloads/Codebase/playground/skills
#   cd ~/Downloads/Codebase/playground/skills
#   ./bootstrap.sh
# ────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "🚀 Skills 初始化設定..."
echo ""

# ── 1. 確保 yq 已安裝（agents.yaml 解析需要） ──
if ! command -v yq &>/dev/null; then
    echo "📦 安裝 yq（YAML 解析工具）..."
    if command -v brew &>/dev/null; then
        brew install yq
    else
        echo "❌ 未找到 Homebrew，請手動安裝 yq：https://github.com/mikefarah/yq"
        exit 1
    fi
fi

# ── 2. 初始化所有 submodule ──
echo "📦 初始化 git submodule..."
git submodule update --init --recursive

# ── 3. 執行 skill 分發 ──
echo ""
echo "🔗 分發 skill 到各 Agent..."
./install.sh

echo ""
echo "🎉 完成！所有 skill 已同步到本機各 AI Agent。"

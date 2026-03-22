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

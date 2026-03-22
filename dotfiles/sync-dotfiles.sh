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

#!/usr/bin/env bash
# OpenClaw Local Security Audit Script
# Performs deep security checks on a local OpenClaw installation.
# Usage: bash security_audit.sh [--state-dir PATH]
#
# Checks:
#   1. File/directory permissions
#   2. Credential exposure (tokens/keys in config)
#   3. Network binding & auth configuration
#   4. Sandbox & tool policy settings
#   5. DM policy & group access openness
#   6. Log redaction settings
#   7. Plugin/extension review
#   8. Gateway process exposure
#   9. Listening port checks
#  10. Sensitive files in synced/shared folders

set -euo pipefail

STATE_DIR="${HOME}/.openclaw"
SEVERITY_COUNTS=()
CRITICAL=0
WARNING=0
INFO=0
PASS=0

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --state-dir) STATE_DIR="$2"; shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

CONFIG_FILE="${STATE_DIR}/openclaw.json"

# --- Helpers ---
red()    { printf '\033[0;31m%s\033[0m\n' "$*"; }
yellow() { printf '\033[0;33m%s\033[0m\n' "$*"; }
green()  { printf '\033[0;32m%s\033[0m\n' "$*"; }
blue()   { printf '\033[0;34m%s\033[0m\n' "$*"; }

critical() { red    "[CRITICAL] $*"; ((CRITICAL++)) || true; }
warning()  { yellow "[WARNING]  $*"; ((WARNING++))  || true; }
info()     { blue   "[INFO]     $*"; ((INFO++))     || true; }
pass()     { green  "[PASS]     $*"; ((PASS++))     || true; }

header() {
  echo ""
  echo "============================================"
  echo "  $*"
  echo "============================================"
}

# --- Pre-checks ---
header "OpenClaw Security Audit"
echo "State directory: ${STATE_DIR}"
echo "Config file:     ${CONFIG_FILE}"
echo "Date:            $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
echo ""

if [[ ! -d "${STATE_DIR}" ]]; then
  critical "State directory ${STATE_DIR} does not exist. Is OpenClaw installed?"
  echo ""
  echo "Summary: ${CRITICAL} critical, ${WARNING} warnings, ${INFO} info, ${PASS} passed"
  exit 1
fi

if [[ ! -f "${CONFIG_FILE}" ]]; then
  critical "Config file ${CONFIG_FILE} not found."
fi

# --- 1. File Permissions ---
header "1. File & Directory Permissions"

check_perms() {
  local path="$1"
  local expected="$2"
  local label="$3"

  if [[ ! -e "$path" ]]; then
    info "${label}: path does not exist (${path})"
    return
  fi

  local actual
  if [[ "$(uname)" == "Darwin" ]]; then
    actual=$(stat -f '%Lp' "$path" 2>/dev/null || echo "???")
  else
    actual=$(stat -c '%a' "$path" 2>/dev/null || echo "???")
  fi

  if [[ "$actual" == "$expected" ]]; then
    pass "${label}: permissions ${actual} (expected ${expected})"
  else
    if [[ "$actual" =~ ^[0-7]*[4567][0-7]$ ]] || [[ "$actual" == "777" ]] || [[ "$actual" == "755" && "$expected" == "700" ]]; then
      critical "${label}: permissions ${actual} (expected ${expected}) — others/group can access"
    else
      warning "${label}: permissions ${actual} (expected ${expected})"
    fi
  fi
}

check_perms "${STATE_DIR}" "700" "State directory (~/.openclaw)"
check_perms "${CONFIG_FILE}" "600" "Config file (openclaw.json)"

# Check credential files
if [[ -d "${STATE_DIR}/credentials" ]]; then
  while IFS= read -r -d '' cred_file; do
    check_perms "$cred_file" "600" "Credential: $(basename "$cred_file")"
  done < <(find "${STATE_DIR}/credentials" -type f -print0 2>/dev/null)
fi

# Check agent auth profiles
while IFS= read -r -d '' auth_file; do
  check_perms "$auth_file" "600" "Auth profile: ${auth_file#${STATE_DIR}/}"
done < <(find "${STATE_DIR}/agents" -name "auth-profiles.json" -print0 2>/dev/null)

# --- 2. Credential Exposure in Config ---
header "2. Credential Exposure in Config"

if [[ -f "${CONFIG_FILE}" ]]; then
  # Check for inline tokens/keys (not env var references)
  config_content=$(cat "${CONFIG_FILE}" 2>/dev/null || echo "")

  # Look for hardcoded API keys (not env var references like $ANTHROPIC_API_KEY)
  if echo "$config_content" | grep -qiE '"(api[_-]?key|token|secret|password)"\s*:\s*"[^$][^"]{8,}"'; then
    critical "Hardcoded secrets found in config file. Use environment variables instead."
    echo "         Matches:"
    echo "$config_content" | grep -inE '"(api[_-]?key|token|secret|password)"\s*:\s*"[^$][^"]{8,}"' | head -5 | while read -r line; do
      echo "           $line"
    done
  else
    pass "No obvious hardcoded secrets in config (or using env var references)"
  fi

  # Check for weak/short tokens
  if echo "$config_content" | grep -qE '"token"\s*:\s*"[^"]{1,15}"'; then
    warning "Short token detected (< 16 chars). Use: openssl rand -hex 32"
  fi
fi

# --- 3. Network Binding & Auth ---
header "3. Network Binding & Authentication"

if [[ -f "${CONFIG_FILE}" ]]; then
  # Check gateway bind
  bind_value=$(echo "$config_content" | grep -oE '"bind"\s*:\s*"[^"]*"' | head -1 | grep -oE '"[^"]*"$' | tr -d '"')

  if [[ -z "$bind_value" ]] || [[ "$bind_value" == "loopback" ]]; then
    pass "Gateway bind: loopback (local only)"
  elif [[ "$bind_value" == "lan" ]]; then
    warning "Gateway bind: lan — exposed to local network. Ensure auth token is set and firewall configured."
  elif [[ "$bind_value" == "0.0.0.0" ]] || [[ "$bind_value" == "custom" ]]; then
    critical "Gateway bind: ${bind_value} — publicly exposed! Verify auth + firewall."
  else
    info "Gateway bind: ${bind_value}"
  fi

  # Check auth mode
  auth_mode=$(echo "$config_content" | grep -oE '"mode"\s*:\s*"(token|password)"' | head -1 | grep -oE '(token|password)')
  auth_token=$(echo "$config_content" | grep -oE '"token"\s*:\s*"[^"]*"' | head -1)

  if [[ -n "$auth_mode" ]]; then
    pass "Gateway auth mode: ${auth_mode}"
  else
    if [[ "$bind_value" != "loopback" ]] && [[ -n "$bind_value" ]]; then
      critical "No auth mode configured with non-loopback bind!"
    else
      info "No auth mode configured (acceptable for loopback)"
    fi
  fi
fi

# --- 4. DM Policy & Group Access ---
header "4. DM Policy & Group Access Control"

if [[ -f "${CONFIG_FILE}" ]]; then
  # Check for open DM policies
  if echo "$config_content" | grep -qE '"dmPolicy"\s*:\s*"open"'; then
    critical "DM policy set to 'open' — anyone can message the bot! Use 'pairing' or 'allowlist'."
  elif echo "$config_content" | grep -qE '"dmPolicy"\s*:\s*"pairing"'; then
    pass "DM policy: pairing (unknown senders need approval)"
  elif echo "$config_content" | grep -qE '"dmPolicy"\s*:\s*"allowlist"'; then
    pass "DM policy: allowlist (only approved senders)"
  elif echo "$config_content" | grep -qE '"dmPolicy"\s*:\s*"disabled"'; then
    pass "DM policy: disabled"
  else
    info "DM policy not explicitly set (defaults to 'pairing')"
  fi

  # Check for wildcard allowFrom
  if echo "$config_content" | grep -qE '"allowFrom"\s*:\s*\[\s*"\*"\s*\]'; then
    critical "allowFrom contains wildcard '*' — allows all senders!"
  fi

  # Check requireMention for groups
  if echo "$config_content" | grep -qE '"requireMention"\s*:\s*false'; then
    warning "Some groups have requireMention: false — bot responds to all messages in those groups."
  fi
fi

# --- 5. Sandbox & Tool Policies ---
header "5. Sandbox & Tool Policies"

if [[ -f "${CONFIG_FILE}" ]]; then
  # Sandbox mode
  sandbox_mode=$(echo "$config_content" | grep -oE '"mode"\s*:\s*"(off|non-main|all)"' | head -1 | grep -oE '(off|non-main|all)')
  if [[ "$sandbox_mode" == "off" ]]; then
    warning "Sandbox mode: off — all sessions run unsandboxed on host."
  elif [[ "$sandbox_mode" == "non-main" ]]; then
    pass "Sandbox mode: non-main (non-owner sessions sandboxed)"
  elif [[ "$sandbox_mode" == "all" ]]; then
    pass "Sandbox mode: all (maximum isolation)"
  else
    info "Sandbox mode not explicitly set"
  fi

  # Check for elevated tools
  if echo "$config_content" | grep -qE '"elevated"\s*:\s*\{' && echo "$config_content" | grep -qE '"enabled"\s*:\s*true'; then
    warning "Elevated mode enabled — agents can execute on host. Check allowFrom restrictions."
  fi

  # Check tool profile
  tool_profile=$(echo "$config_content" | grep -oE '"profile"\s*:\s*"(minimal|coding|messaging|full)"' | head -1 | grep -oE '(minimal|coding|messaging|full)')
  if [[ "$tool_profile" == "full" ]]; then
    warning "Tool profile: full — all tools enabled. Consider restricting for untrusted channels."
  elif [[ -n "$tool_profile" ]]; then
    pass "Tool profile: ${tool_profile}"
  fi

  # Check docker network for sandbox
  if echo "$config_content" | grep -qE '"network"\s*:\s*"(bridge|host)"'; then
    warning "Sandbox docker network is not 'none' — containers have network access."
  fi
fi

# --- 6. Log Redaction ---
header "6. Logging & Redaction"

if [[ -f "${CONFIG_FILE}" ]]; then
  if echo "$config_content" | grep -qE '"redactSensitive"\s*:\s*"off"'; then
    warning "Log redaction is OFF — sensitive data may appear in logs."
  elif echo "$config_content" | grep -qE '"redactSensitive"\s*:\s*"tools"'; then
    pass "Log redaction: tools (tool output redacted)"
  else
    info "Log redaction not explicitly set"
  fi
fi

# Check log file permissions
LOG_DIR="/tmp/openclaw"
if [[ -d "$LOG_DIR" ]]; then
  log_perms=$(stat -f '%Lp' "$LOG_DIR" 2>/dev/null || stat -c '%a' "$LOG_DIR" 2>/dev/null || echo "???")
  if [[ "$log_perms" =~ [4567][0-7][0-7] ]] && [[ "$log_perms" != "700" ]]; then
    warning "Log directory ${LOG_DIR} permissions: ${log_perms} (consider 700)"
  else
    pass "Log directory permissions: ${log_perms}"
  fi
fi

# --- 7. Plugins & Extensions ---
header "7. Plugins & Extensions"

EXTENSIONS_DIR="${STATE_DIR}/extensions"
if [[ -d "$EXTENSIONS_DIR" ]]; then
  plugin_count=$(find "$EXTENSIONS_DIR" -maxdepth 1 -type d | wc -l | tr -d ' ')
  ((plugin_count--)) || true  # subtract the directory itself
  if [[ $plugin_count -gt 0 ]]; then
    warning "${plugin_count} plugin(s) installed. Review each for trust:"
    find "$EXTENSIONS_DIR" -maxdepth 1 -type d | tail -n +2 | while read -r p; do
      echo "           - $(basename "$p")"
    done
  else
    pass "No plugins installed"
  fi
else
  pass "No extensions directory found"
fi

# --- 8. Gateway Process ---
header "8. Gateway Process"

gateway_pid=$(pgrep -f "openclaw.*gateway" 2>/dev/null || true)
if [[ -n "$gateway_pid" ]]; then
  info "Gateway process running (PID: ${gateway_pid})"

  # Check listening ports
  if command -v lsof &>/dev/null; then
    listening=$(lsof -i -P -n 2>/dev/null | grep "$gateway_pid" | grep LISTEN || true)
    if [[ -n "$listening" ]]; then
      echo "         Listening on:"
      echo "$listening" | while read -r line; do
        echo "           $line"
        if echo "$line" | grep -qE '\*:|\b0\.0\.0\.0:'; then
          critical "Gateway listening on all interfaces (0.0.0.0)!"
        fi
      done
    fi
  fi
else
  info "Gateway process not currently running"
fi

# --- 9. Sensitive Files in Synced Folders ---
header "9. Sensitive Data Location Check"

# Check if state dir is inside common synced folders
synced_dirs=("$HOME/Dropbox" "$HOME/Google Drive" "$HOME/OneDrive" "$HOME/iCloud" "$HOME/Library/Mobile Documents")
for sync_dir in "${synced_dirs[@]}"; do
  if [[ "${STATE_DIR}" == "${sync_dir}"* ]]; then
    critical "OpenClaw state directory is inside a synced folder: ${sync_dir}"
    echo "         Move to a non-synced location to prevent credential exposure."
  fi
done
pass "State directory not in common synced folders"

# Check for .env files with secrets
if [[ -f "${STATE_DIR}/.env" ]]; then
  env_perms=$(stat -f '%Lp' "${STATE_DIR}/.env" 2>/dev/null || stat -c '%a' "${STATE_DIR}/.env" 2>/dev/null || echo "???")
  if [[ "$env_perms" != "600" ]]; then
    warning ".env file permissions: ${env_perms} (expected 600)"
  else
    pass ".env file permissions: 600"
  fi
fi

# --- 10. Session Transcript Quick Scan ---
header "10. Session Transcript Secret Scan (sampling)"

secret_patterns='(sk-[a-zA-Z0-9]{20,}|AKIA[A-Z0-9]{16}|ghp_[a-zA-Z0-9]{36}|xoxb-[0-9]+-[a-zA-Z0-9]+|-----BEGIN (RSA |EC )?PRIVATE KEY-----)'
leaked_count=0

# Sample up to 10 recent session files (portable: no head -z which is GNU-only)
sample_count=0
while IFS= read -r -d '' session_file; do
  if [[ $sample_count -ge 10 ]]; then
    break
  fi
  if grep -qE "$secret_patterns" "$session_file" 2>/dev/null; then
    ((leaked_count++)) || true
    warning "Potential secret found in transcript: ${session_file#${STATE_DIR}/}"
  fi
  ((sample_count++)) || true
done < <(find "${STATE_DIR}/agents" -name "*.jsonl" -type f -print0 2>/dev/null)

if [[ $leaked_count -eq 0 ]]; then
  pass "No obvious secrets found in sampled session transcripts"
fi

# --- Summary ---
header "Audit Summary"
echo ""
echo "  $(red   "${CRITICAL} CRITICAL")"
echo "  $(yellow "${WARNING} Warnings")"
echo "  $(blue   "${INFO} Informational")"
echo "  $(green  "${PASS} Passed")"
echo ""

if [[ $CRITICAL -gt 0 ]]; then
  red "ACTION REQUIRED: Fix critical issues before continuing."
  exit 2
elif [[ $WARNING -gt 0 ]]; then
  yellow "Review warnings and harden where possible."
  exit 0
else
  green "All checks passed. Installation looks secure."
  exit 0
fi

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── Defaults ──────────────────────────────────
INPUT=""
MODEL=""
LANGUAGE="zh"
FORMAT="txt"
TASK="transcribe"
OUTPUT_DIR=""
BACKEND="auto"
PROMPT=""

# ── Parse args ────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --input)    INPUT="$2";      shift 2 ;;
    --model)    MODEL="$2";      shift 2 ;;
    --language) LANGUAGE="$2";   shift 2 ;;
    --format)   FORMAT="$2";     shift 2 ;;
    --output)   OUTPUT_DIR="$2"; shift 2 ;;
    --task)     TASK="$2";       shift 2 ;;
    --backend)  BACKEND="$2";    shift 2 ;;
    --prompt)   PROMPT="$2";     shift 2 ;;
    *)
      echo "{\"tool\":\"transcribe\",\"error\":\"Unknown argument: $1\"}" >&2
      exit 1
      ;;
  esac
done

# ── Validate ──────────────────────────────────
if [[ -z "$INPUT" ]]; then
  echo '{"tool":"transcribe","error":"--input is required"}' >&2
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  echo "{\"tool\":\"transcribe\",\"error\":\"File not found: $INPUT\"}" >&2
  exit 1
fi

case "$FORMAT" in
  txt|srt|vtt|json) ;;
  *) echo "{\"tool\":\"transcribe\",\"error\":\"Invalid format: $FORMAT. Use txt, srt, vtt, or json\"}" >&2; exit 1 ;;
esac

case "$TASK" in
  transcribe|translate) ;;
  *) echo "{\"tool\":\"transcribe\",\"error\":\"Invalid task: $TASK. Use transcribe or translate\"}" >&2; exit 1 ;;
esac

case "$BACKEND" in
  auto|mlx|groq) ;;
  *) echo "{\"tool\":\"transcribe\",\"error\":\"Invalid backend: $BACKEND. Use auto, mlx, or groq\"}" >&2; exit 1 ;;
esac

# ── Resolve output dir ────────────────────────
if [[ -z "$OUTPUT_DIR" ]]; then
  OUTPUT_DIR="$(dirname "$INPUT")"
fi

BASENAME="$(basename "${INPUT%.*}")"

# ── Export shared state for backends ──────────
export INPUT MODEL LANGUAGE FORMAT TASK OUTPUT_DIR BASENAME PROMPT

# ── Backend selection ─────────────────────────
run_mlx() {
  if [[ -z "$MODEL" ]]; then MODEL="mlx-community/whisper-large-v3-turbo"; fi
  export MODEL
  bash "$SCRIPT_DIR/backend_mlx.sh"
}

run_groq() {
  if [[ -z "$MODEL" ]]; then MODEL="whisper-large-v3-turbo"; fi
  export MODEL
  bash "$SCRIPT_DIR/backend_groq.sh"
}

case "$BACKEND" in
  mlx)
    run_mlx
    ;;
  groq)
    run_groq
    ;;
  auto)
    # Strategy: local first (free, offline), cloud fallback
    if sysctl -n machdep.cpu.brand_string 2>/dev/null | grep -q "Apple"; then
      echo "Backend: mlx (Apple Silicon detected)" >&2
      if run_mlx; then
        exit 0
      else
        echo "MLX failed, falling back to Groq..." >&2
      fi
    fi
    # Fallback to Groq
    if [[ -n "${GROQ_API_KEY:-}" ]]; then
      echo "Backend: groq (cloud fallback)" >&2
      run_groq
    else
      echo '{"tool":"transcribe","error":"MLX unavailable and GROQ_API_KEY not set. No backend available."}' >&2
      exit 1
    fi
    ;;
esac

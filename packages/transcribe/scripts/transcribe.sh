#!/usr/bin/env bash
set -euo pipefail

# ── Defaults ──────────────────────────────────
MODEL="mlx-community/whisper-large-v3-turbo"
LANGUAGE="zh"
FORMAT="txt"
TASK="transcribe"
OUTPUT_DIR=""
INPUT=""

VENV_DIR="$HOME/.local/share/transcribe/venv"

# ── Parse args ────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --input)    INPUT="$2";      shift 2 ;;
    --model)    MODEL="$2";      shift 2 ;;
    --language) LANGUAGE="$2";   shift 2 ;;
    --format)   FORMAT="$2";     shift 2 ;;
    --output)   OUTPUT_DIR="$2"; shift 2 ;;
    --task)     TASK="$2";       shift 2 ;;
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

# Validate format
case "$FORMAT" in
  txt|srt|vtt|json) ;;
  *) echo "{\"tool\":\"transcribe\",\"error\":\"Invalid format: $FORMAT. Use txt, srt, vtt, or json\"}" >&2; exit 1 ;;
esac

# Validate task
case "$TASK" in
  transcribe|translate) ;;
  *) echo "{\"tool\":\"transcribe\",\"error\":\"Invalid task: $TASK. Use transcribe or translate\"}" >&2; exit 1 ;;
esac

# ── Bootstrap venv (once) ─────────────────────
if [[ ! -f "$VENV_DIR/bin/mlx_whisper" ]]; then
  echo "First run: setting up mlx-whisper environment..." >&2
  mkdir -p "$(dirname "$VENV_DIR")"
  uv venv "$VENV_DIR" >&2
  uv pip install --python "$VENV_DIR/bin/python" mlx-whisper >&2
  echo "Setup complete." >&2
fi

# ── Resolve output ────────────────────────────
if [[ -z "$OUTPUT_DIR" ]]; then
  OUTPUT_DIR="$(dirname "$INPUT")"
fi

BASENAME="$(basename "${INPUT%.*}")"

# ── Run transcription ────────────────────────
# mlx_whisper writes output files to --output-dir
"$VENV_DIR/bin/mlx_whisper" \
  "$INPUT" \
  --model "$MODEL" \
  --language "$LANGUAGE" \
  --task "$TASK" \
  --output-dir "$OUTPUT_DIR" \
  --output-format "$FORMAT" \
  >&2

OUTPUT_FILE="$OUTPUT_DIR/$BASENAME.$FORMAT"

# ── Read result and output JSON ───────────────
if [[ ! -f "$OUTPUT_FILE" ]]; then
  echo "{\"tool\":\"transcribe\",\"error\":\"Output file not created: $OUTPUT_FILE\"}" >&2
  exit 1
fi

# Use Python to safely build JSON output (avoids shell injection in text content)
export OUTPUT_FILE INPUT MODEL LANGUAGE TASK
"$VENV_DIR/bin/python" -c "
import json, sys, os

output_file = os.environ['OUTPUT_FILE']
with open(output_file, 'r', encoding='utf-8') as f:
    text = f.read().strip()

result = {
    'tool': 'transcribe',
    'input': os.environ['INPUT'],
    'output': output_file,
    'model': os.environ['MODEL'],
    'language': os.environ['LANGUAGE'],
    'task': os.environ['TASK'],
    'text': text
}
json.dump(result, sys.stdout, ensure_ascii=False, indent=2)
print()
"

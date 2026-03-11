#!/usr/bin/env bash
set -euo pipefail

# ── MLX Whisper backend (local, Apple Silicon) ──
# Called by transcribe.sh — do not run directly.

MODEL="${MODEL:-mlx-community/whisper-large-v3-turbo}"
VENV_DIR="$HOME/.local/share/transcribe/venv"

# ── Bootstrap venv (once) ─────────────────────
if [[ ! -f "$VENV_DIR/bin/mlx_whisper" ]]; then
  echo "First run: setting up mlx-whisper environment..." >&2
  mkdir -p "$(dirname "$VENV_DIR")"
  uv venv "$VENV_DIR" >&2
  uv pip install --python "$VENV_DIR/bin/python" mlx-whisper >&2
  echo "Setup complete." >&2
fi

# ── Run transcription ────────────────────────
"$VENV_DIR/bin/mlx_whisper" \
  "$INPUT" \
  --model "$MODEL" \
  --language "$LANGUAGE" \
  --task "$TASK" \
  --output-dir "$OUTPUT_DIR" \
  --output-format "$FORMAT" \
  >&2

OUTPUT_FILE="$OUTPUT_DIR/$BASENAME.$FORMAT"

if [[ ! -f "$OUTPUT_FILE" ]]; then
  echo "{\"tool\":\"transcribe\",\"error\":\"Output file not created: $OUTPUT_FILE\"}" >&2
  exit 1
fi

# ── Output JSON ───────────────────────────────
export OUTPUT_FILE
"$VENV_DIR/bin/python" -c "
import json, sys, os
with open(os.environ['OUTPUT_FILE'], 'r', encoding='utf-8') as f:
    text = f.read().strip()
result = {
    'tool': 'transcribe',
    'backend': 'mlx',
    'input': os.environ['INPUT'],
    'output': os.environ['OUTPUT_FILE'],
    'model': os.environ['MODEL'],
    'language': os.environ['LANGUAGE'],
    'task': os.environ['TASK'],
    'text': text
}
json.dump(result, sys.stdout, ensure_ascii=False, indent=2)
print()
"

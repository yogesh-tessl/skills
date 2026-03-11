#!/usr/bin/env bash
set -euo pipefail

# ── Groq Whisper backend (cloud API) ──
# Called by transcribe.sh — do not run directly.

MODEL="${MODEL:-whisper-large-v3-turbo}"
PROMPT="${PROMPT:-}"

# ── Validate ──────────────────────────────────
if [[ -z "${GROQ_API_KEY:-}" ]]; then
  echo '{"tool":"transcribe","backend":"groq","error":"GROQ_API_KEY not set"}' >&2
  exit 1
fi

if [[ "$TASK" == "translate" ]]; then
  echo '{"tool":"transcribe","backend":"groq","error":"Groq API does not support translate task. Use --backend mlx."}' >&2
  exit 1
fi

case "$FORMAT" in
  txt|json) ;;
  srt|vtt)
    echo '{"tool":"transcribe","backend":"groq","error":"Groq API only supports txt/json output. Use --backend mlx for srt/vtt."}' >&2
    exit 1
    ;;
esac

# ── Map language code ─────────────────────────
GROQ_LANG="$LANGUAGE"
case "$LANGUAGE" in
  zh) GROQ_LANG="zh-TW" ;;
esac

# ── Call Groq API ─────────────────────────────
CURL_ARGS=(
  -s -w "\n%{http_code}" -X POST "https://api.groq.com/openai/v1/audio/transcriptions"
  -H "Authorization: Bearer $GROQ_API_KEY"
  -F "file=@$INPUT"
  -F "model=$MODEL"
  -F "language=$GROQ_LANG"
  -F "response_format=json"
)
if [[ -n "$PROMPT" ]]; then
  CURL_ARGS+=(-F "prompt=$PROMPT")
fi

RAW=$(curl "${CURL_ARGS[@]}")
HTTP_CODE=$(echo "$RAW" | tail -1)
RESPONSE=$(echo "$RAW" | sed '$d')

# ── Check for errors (by HTTP status, not string grep) ──
if [[ "$HTTP_CODE" -lt 200 || "$HTTP_CODE" -ge 300 ]]; then
  ERR_MSG=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('error',{}).get('message','HTTP $HTTP_CODE'))" 2>/dev/null || echo "HTTP $HTTP_CODE")
  printf '{"tool":"transcribe","backend":"groq","error":"%s"}\n' "$ERR_MSG" >&2
  exit 1
fi

# ── Write output file & emit JSON ─────────────
OUTPUT_FILE="$OUTPUT_DIR/$BASENAME.$FORMAT"
export OUTPUT_FILE GROQ_LANG RESPONSE

python3 -c "
import json, sys, os

response = json.loads(os.environ['RESPONSE'])
text = response['text']

# Write output file
output_file = os.environ['OUTPUT_FILE']
fmt = os.environ.get('FORMAT', 'txt')
if fmt == 'json':
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(response, f, ensure_ascii=False, indent=2)
else:
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(text + '\n')

# Emit result
result = {
    'tool': 'transcribe',
    'backend': 'groq',
    'input': os.environ['INPUT'],
    'output': output_file,
    'model': os.environ['MODEL'],
    'language': os.environ['GROQ_LANG'],
    'task': os.environ['TASK'],
    'text': text
}
json.dump(result, sys.stdout, ensure_ascii=False, indent=2)
print()
"

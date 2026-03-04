---
name: transcribe
description: >
  Speech-to-text with automatic backend selection: local MLX Whisper (Apple Silicon) or Groq cloud API.
  Supports 99 languages, defaults to Traditional Chinese (zh-TW).
  Use for transcribing audio/video files to text, generating subtitles (SRT/VTT), or translating speech to English.
  Triggers: "transcribe", "語音轉文字", "轉錄", "聽打", "ASR", "speech to text", "whisper",
  "字幕", "subtitle", "逐字稿"
allowed-tools: Bash(transcribe:*)
---

# Transcribe

Speech-to-text with two backends: **MLX Whisper** (local, Apple Silicon) and **Groq API** (cloud).
Default mode `auto` uses local first, cloud as fallback.

## Usage

```bash
bash scripts/transcribe.sh --input "/path/to/audio.m4a"
```

### Options

| Flag | Description | Default |
|------|-------------|---------|
| `--input FILE` | Audio/video file path (required) | — |
| `--backend MODE` | `auto`, `mlx`, or `groq` | `auto` |
| `--model MODEL` | Whisper model name | Per backend |
| `--language LANG` | Language code (`zh`, `en`, `ja`, etc.) | `zh` |
| `--format FORMAT` | Output: `txt`, `srt`, `vtt`, `json` | `txt` |
| `--output DIR` | Output directory | Same as input file |
| `--task TASK` | `transcribe` or `translate` (to English) | `transcribe` |
| `--prompt TEXT` | Context hint for better accuracy (Groq only) | — |

### Backends

| Backend | Where | Speed | Cost | Offline | SRT/VTT |
|---------|-------|-------|------|---------|---------|
| `mlx` | Local (Apple Silicon) | Fast | Free | Yes | Yes |
| `groq` | Groq Cloud API | Very Fast | Free tier 16k req/mo | No | No |
| `auto` | MLX first, Groq fallback | — | — | Degrades gracefully | — |

### MLX Models

| Model | Speed | Accuracy | VRAM |
|-------|-------|----------|------|
| `mlx-community/whisper-large-v3-mlx` | Slow | Best | ~3 GB |
| `mlx-community/whisper-large-v3-turbo` | Fast | Very Good | ~1.6 GB |
| `mlx-community/whisper-small-mlx` | Very Fast | Good | ~0.5 GB |

### Examples

```bash
# Default: auto backend, zh-TW
bash scripts/transcribe.sh --input "meeting.m4a"

# Force local
bash scripts/transcribe.sh --input "meeting.m4a" --backend mlx

# Force cloud (with context hint)
bash scripts/transcribe.sh --input "meeting.m4a" --backend groq --prompt "技術術語: Bitcoin, DeFi"

# English, SRT subtitles (requires mlx)
bash scripts/transcribe.sh --input "video.mp4" --language en --format srt

# Translate any language to English
bash scripts/transcribe.sh --input "講座.m4a" --task translate
```

## Output

JSON on stdout:

```json
{
  "tool": "transcribe",
  "backend": "mlx",
  "input": "/path/to/audio.m4a",
  "output": "/path/to/audio.txt",
  "model": "mlx-community/whisper-large-v3-turbo",
  "language": "zh",
  "task": "transcribe",
  "text": "轉錄的文字內容..."
}
```

## Setup

- **MLX**: Auto-bootstraps venv at `~/.local/share/transcribe/venv` on first run (requires `uv`).
- **Groq**: Set `GROQ_API_KEY` env var, or configure in `openclaw.json` under `skills.entries.transcribe.apiKey`.

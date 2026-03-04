---
name: transcribe
description: >
  On-device speech-to-text using MLX Whisper on Apple Silicon. Supports 99 languages, defaults to
  Traditional Chinese (zh-TW). Use for transcribing audio/video files to text, generating subtitles
  (SRT/VTT), or translating speech to English.
  Triggers: "transcribe", "語音轉文字", "轉錄", "聽打", "ASR", "speech to text", "whisper",
  "字幕", "subtitle", "逐字稿"
allowed-tools: Bash(transcribe:*)
---

# Transcribe

On-device speech-to-text via [MLX Whisper](https://github.com/ml-explore/mlx-examples/tree/main/whisper) on Apple Silicon.

## Usage

```bash
bash scripts/transcribe.sh --input "/path/to/audio.m4a"
```

### Options

| Flag | Description | Default |
|------|-------------|---------|
| `--input FILE` | Audio/video file path (required) | — |
| `--model MODEL` | Whisper model name | `mlx-community/whisper-large-v3-turbo` |
| `--language LANG` | Language code (`zh`, `en`, `ja`, `ko`, etc.) | `zh` |
| `--format FORMAT` | Output: `txt`, `srt`, `vtt`, `json` | `txt` |
| `--output DIR` | Output directory | Same as input file |
| `--task TASK` | `transcribe` or `translate` (to English) | `transcribe` |

### Models

| Model | Speed | Accuracy | VRAM |
|-------|-------|----------|------|
| `mlx-community/whisper-large-v3-mlx` | Slow | Best | ~3 GB |
| `mlx-community/whisper-large-v3-turbo` | Fast | Very Good | ~1.6 GB |
| `mlx-community/whisper-small-mlx` | Very Fast | Good | ~0.5 GB |

### Examples

```bash
# zh-TW transcription (default)
bash scripts/transcribe.sh --input "meeting.m4a"

# English transcription
bash scripts/transcribe.sh --input "interview.wav" --language en

# SRT subtitles
bash scripts/transcribe.sh --input "video.mp4" --format srt

# Translate any language to English
bash scripts/transcribe.sh --input "講座.m4a" --task translate
```

## Output

JSON on stdout:

```json
{
  "tool": "transcribe",
  "input": "/path/to/audio.m4a",
  "output": "/path/to/audio.txt",
  "model": "mlx-community/whisper-large-v3-turbo",
  "language": "zh",
  "text": "轉錄的文字內容..."
}
```

## First Run

The script auto-bootstraps a venv at `~/.local/share/transcribe/venv` using `uv` and installs `mlx-whisper`. Model weights are cached by HuggingFace after first download.

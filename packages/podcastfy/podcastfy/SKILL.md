---
name: podcastfy
description: >
  Use when the user wants to turn web content, text, or topics into audio.
  Triggers: "podcast", "generate podcast", "turn this into a podcast", "make audio from",
  "article to audio", "audio version", "listen to this article", "I want to listen to this",
  "轉成 podcast", "把這篇變成 podcast", "做成 podcast", "我想聽這篇",
  "幫我把這個做成音檔", "做成音頻". Supports English and Traditional Chinese (zh-tw) output.
---

# Podcastfy — Article-to-Podcast Skill

Convert web articles, text, or topics into multi-speaker podcast conversations as MP3 files.

## Requirements

- **API key**: `GEMINI_API_KEY` (free tier at aistudio.google.com) OR `OPENAI_API_KEY`
- **Python / packages**: Auto-installed on first run (~2 min, once only)

## Workflow

1. Determine input type (`url`, `text`, or `topic`) and preferred style
2. Run `generate_podcast.py` directly — it self-bootstraps if needed
3. Return the absolute MP3 path to the user

> **Paywall/JS-heavy sites** (Wired, NYT, etc.) will fail URL extraction.
> Fall back to `--input-type topic` with a descriptive summary of the article subject.

## Usage

```bash
python3 scripts/generate_podcast.py \
  --input "<url, text, or topic>" \
  --input-type <url|text|topic> \
  --style <deep-dive|casual|news-brief> \
  --tts-model <edge|openai|elevenlabs|gemini> \
  --language <zh|en|ja|…> \
  --output-dir <path>
```

| Parameter | Default | Description |
|-----------|---------|-------------|
| `--input` | required | URL, raw text, or topic string |
| `--input-type` | `url` | `url` / `text` / `topic` |
| `--style` | `deep-dive` | `deep-dive` / `casual` / `news-brief` |
| `--tts-model` | `edge` (free) | `edge` / `openai` / `elevenlabs` / `gemini` |
| `--language` | auto (follows source) | Output language: `en`, `zh-tw`, etc. Also translates source content. |
| `--output-dir` | `.` (cwd) | Where to save the MP3 |

Style details in `references/conversation_styles.yaml`. Script prints the MP3 absolute path to stdout.

## Examples

```bash
# English article → English podcast (primary use case, language learning)
python3 scripts/generate_podcast.py \
  --input "https://example.com/article" --style deep-dive

# English article → Traditional Chinese podcast (translation + audio in one step)
python3 scripts/generate_podcast.py \
  --input "https://example.com/article" --language zh-tw --style casual

# Traditional Chinese topic → Chinese podcast
python3 scripts/generate_podcast.py \
  --input "台灣半導體的全球戰略地位" --input-type topic --language zh-tw --style news-brief

# Paywall/JS-heavy sites (Wired, NYT): use topic fallback
python3 scripts/generate_podcast.py \
  --input "GPS spoofing attacks on ships near Iran" --input-type topic --style deep-dive
```

> **Chinese audio**: Always use `--language zh-tw` for Traditional Chinese voices.
> `--language zh` also resolves to Traditional Chinese (zh-TW) voices.

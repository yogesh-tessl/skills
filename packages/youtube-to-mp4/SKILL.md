---
name: youtube-to-mp4
description: >
  Download YouTube videos and convert them to MP4 format using yt-dlp and ffmpeg.
  Use this skill whenever the user wants to download YouTube videos, convert YouTube
  videos to MP4, grab videos from YouTube, save YouTube content locally, download
  playlists, or extract video with subtitles. Also triggers when the user mentions
  yt-dlp, youtube-dl, or asks to embed a YouTube video into a presentation/PPTX.
  Handles single videos, multiple URLs, and playlists. Also use when the user asks
  to extract audio from YouTube (e.g., "turn this YouTube video into an audio file").
  Chinese triggers: 下載 YouTube、YouTube 轉檔、YouTube 下載、抓 YouTube 影片、
  YouTube 轉 MP4、YouTube 擷取音訊。
---

# YouTube to MP4

Download YouTube videos and convert to MP4 format optimized for local playback and PPTX embedding.

## Prerequisites

Ensure both tools are installed via Homebrew:

```bash
brew install yt-dlp ffmpeg
```

If either is missing, inform the user and provide the install command before proceeding.

## Workflow

### Step 1: Check dependencies

Run `which yt-dlp && which ffmpeg` to verify both are available. If not, stop and tell the user what to install.

Then check if yt-dlp is reasonably up-to-date — YouTube frequently changes its anti-scraping mechanisms and older versions often fail silently or with cryptic errors:

```bash
yt-dlp --version
```

The output is a date in `YYYY.MM.DD` format (e.g., `2025.12.06`). Compare it against today's date. If the version is more than 3 months old, suggest the user update before proceeding:

```bash
brew upgrade yt-dlp
```

### Step 2: Determine output directory

- Use the user's specified directory if provided
- Otherwise use the current working directory
- Check writability with `test -w "<dir>"` — fall back to `~/Downloads` if the current directory is not writable

### Step 3: Download

Every yt-dlp invocation shares these base flags — the format selector tries native MP4 streams first, falling back to best available, and `--merge-output-format` ensures the container is always MP4. This means ffmpeg conversion is often unnecessary.

```
BASE_FLAGS:
  -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
  --merge-output-format mp4
```

Compose the full command by combining `BASE_FLAGS` with the appropriate output template:

| Mode | Output template (`-o`) | Extra flags |
|------|----------------------|-------------|
| Single video | `<output_dir>/%(title)s.%(ext)s` | — |
| Multiple URLs | `<output_dir>/%(title)s.%(ext)s` | Pass all URLs as trailing arguments |
| Playlist | `<output_dir>/%(playlist_title)s/%(playlist_index)03d - %(title)s.%(ext)s` | `--yes-playlist` |

**Example (single video):**
```bash
yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" \
  --merge-output-format mp4 \
  -o '<output_dir>/%(title)s.%(ext)s' \
  '<url>'
```

### Step 4: Audio-only extraction (only when the user asks for audio)

When the user wants audio only (e.g., "turn this into an MP3", "extract the audio"), use `-x` to extract and convert:

```bash
yt-dlp -x --audio-format mp3 --audio-quality 0 \
  -o '<output_dir>/%(title)s.%(ext)s' \
  '<url>'
```

- `--audio-format mp3`: Most compatible format. Use `m4a` or `opus` if the user prefers higher quality or smaller size.
- `--audio-quality 0`: Best quality (VBR ~245 kbps for MP3). Adjust if the user wants smaller files.

Skip Steps 5 (post-download conversion) when doing audio-only extraction — yt-dlp handles the conversion internally.

### Step 5: Subtitles (only when the user explicitly requests)

Add these flags to the yt-dlp command when subtitles are wanted:

```
--write-subs --write-auto-subs --sub-langs "<langs>" --sub-format srt
```

For `--sub-langs`, pick languages based on context:
- If the user specifies languages, use those exact codes.
- If the user's system locale or conversation language gives a hint, use `en` plus that language (e.g., `en,zh-Hant` for Traditional Chinese users).
- If no context is available, default to `en` only.
- Use `--sub-langs all` if the user explicitly wants every available language.

### Step 6: Post-download conversion (only if needed)

After download, check if the output is already MP4 with H.264 video:

```bash
ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of csv=p=0 '<file>'
```

**If the file is already H.264 MP4** — done, no conversion needed.

**If conversion is needed** (e.g., webm, mkv, or non-H.264 codec):

```bash
ffmpeg -i '<input_file>' \
  -c:v libx264 -preset medium -crf 23 \
  -pix_fmt yuv420p \
  -c:a aac -b:a 128k \
  -movflags +faststart \
  '<output_file>.mp4'
```

Settings rationale:
- `crf 23`: Good visual quality at reasonable file size — sufficient for PPTX embedding and screen playback. Lower source resolution videos won't benefit from lower CRF values.
- `yuv420p`: Maximum compatibility with players and PowerPoint.
- `aac 128k`: Clear audio, compact size.
- `movflags +faststart`: Moves metadata to the front so the video starts playing immediately when embedded.

After conversion, verify the output file exists and has a non-zero size before deleting the intermediate file:

```bash
if [ -s '<output_file>.mp4' ]; then
  rm '<input_file>'
else
  echo "Conversion may have failed — keeping original file"
fi
```

This prevents data loss if the conversion was interrupted (e.g., disk full, process killed).

### Step 7: Report results

After all downloads and conversions complete, report:
- File name(s) and location
- File size(s)
- Video resolution (from ffprobe if useful)
- Whether subtitles were downloaded

### PPTX embedding

This skill only handles downloading and converting the video. If the user also wants to embed the video into a PowerPoint file, hand off to the `pptx` skill after the MP4 file is ready. Inform the user that the video is optimized for embedding (H.264, `movflags +faststart`, `yuv420p`).

## Edge Cases

- **Filenames with special characters**: Video titles may contain quotes, slashes, or other shell-unsafe characters. Add `--restrict-filenames` to replace problematic characters with underscores, or use `--output` with double quotes and let yt-dlp handle escaping internally.
- **Age-restricted videos**: Add `--cookies-from-browser <browser>` if yt-dlp reports age restriction errors, where `<browser>` is the user's browser (chrome, firefox, safari, edge, arc). Ask the user which browser they use rather than assuming Chrome. Inform them this reads browser cookies.
- **Long filenames**: If the title is very long, use `-o` with `%(title).100s` to truncate.
- **Already downloaded**: yt-dlp skips files that already exist by default. Inform the user if this happens.
- **Rate limiting**: If download fails due to rate limiting, suggest the user try again later or use `--sleep-interval 5`.
- **Private/unavailable videos**: Report the error clearly and continue with remaining URLs if batch downloading.

#!/usr/bin/env python3
"""Generate a podcast MP3 from URL, text, or topic using Podcastfy.

Self-bootstrapping: auto-creates a venv and installs all dependencies on first run.
Claude should call this script directly — no manual setup needed.
"""

import os
import sys
import shutil
import subprocess
from pathlib import Path

VENV_DIR = Path(os.environ.get("PODCASTFY_VENV") or Path.home() / ".podcastfy-venv")
VENV_PYTHON = VENV_DIR / "bin" / "python3"
SENTINEL = VENV_DIR / ".ready"
PACKAGES = ["podcastfy", "pyyaml", "playwright", "audioop-lts"]


# ── Bootstrap ─────────────────────────────────────────────────────────────────

def _find_python():
    """Return path to Python 3.11–3.13 (podcastfy incompatible with 3.14+)."""
    for candidate in ["python3.13", "python3.12", "python3.11"]:
        path = shutil.which(candidate)
        if path:
            minor = subprocess.run(
                [path, "-c", "import sys; print(sys.version_info.minor)"],
                capture_output=True, text=True,
            ).stdout.strip()
            if minor.isdigit() and 11 <= int(minor) <= 13:
                return path
    return None


def _setup_venv():
    """Create venv, install packages, install Chromium. Writes sentinel on success."""
    print("⚙️  First-time setup: creating venv and installing podcastfy...", flush=True)

    python = _find_python()
    if not python:
        sys.exit(
            "ERROR: Python 3.11–3.13 required (3.14+ not yet supported).\n"
            "Install: brew install python@3.13"
        )

    print(f"   Using {python}", flush=True)
    subprocess.run([python, "-m", "venv", str(VENV_DIR)], check=True)

    print("   Installing packages (takes ~2 min once)...", flush=True)
    subprocess.run([str(VENV_DIR / "bin" / "pip"), "install", "-q"] + PACKAGES, check=True)

    print("   Installing Chromium for Playwright (URL extraction)...", flush=True)
    subprocess.run([str(VENV_PYTHON), "-m", "playwright", "install", "chromium"], check=True)

    SENTINEL.touch()
    print("✅ Setup complete!\n", flush=True)


# If not already in the venv, bootstrap (if needed) and re-exec inside it.
if str(VENV_DIR / "bin") not in sys.executable:
    if not SENTINEL.exists():
        _setup_venv()
    # Sync API keys from ~/.zshrc before re-exec so the venv process inherits fresh values.
    # Claude Code sessions may have stale env vars from launch time.
    for _key in ("GEMINI_API_KEY", "GOOGLE_API_KEY", "OPENAI_API_KEY"):
        _src_key = "GEMINI_API_KEY" if _key == "GOOGLE_API_KEY" else _key
        _zshrc_val = next(
            (l.split("=", 1)[1].strip().strip('"').strip("'")
             for l in (Path.home() / ".zshrc").read_text().splitlines()
             if l.strip().startswith(f"export {_src_key}=")),
            None,
        ) if (Path.home() / ".zshrc").exists() else None
        if _zshrc_val:
            os.environ[_key] = _zshrc_val
    os.execv(str(VENV_PYTHON), [str(VENV_PYTHON)] + sys.argv)  # does not return


# ── Main logic (runs inside venv) ─────────────────────────────────────────────

import argparse
import yaml  # available in venv


def _read_key_from_zshrc(key_name):
    """Fallback: read API key from ~/.zshrc when env var is missing/stale."""
    try:
        for line in (Path.home() / ".zshrc").read_text().splitlines():
            line = line.strip()
            if line.startswith(f"export {key_name}="):
                value = line.split("=", 1)[1].strip().strip('"').strip("'")
                return value or None
    except FileNotFoundError:
        pass
    return None


def detect_llm():
    """Detect available LLM keys (GEMINI > OPENAI). Syncs GOOGLE_API_KEY for podcastfy."""
    gemini = os.environ.get("GEMINI_API_KEY") or _read_key_from_zshrc("GEMINI_API_KEY")
    if gemini:
        # podcastfy's google.genai SDK reads GOOGLE_API_KEY; sync to avoid stale conflicts.
        os.environ["GEMINI_API_KEY"] = os.environ["GOOGLE_API_KEY"] = gemini
        return {"llm_model_name": "gemini-2.5-flash", "api_key_label": "GEMINI_API_KEY"}
    if os.environ.get("OPENAI_API_KEY"):
        return {"llm_model_name": "gpt-4o-mini", "api_key_label": "OPENAI_API_KEY"}
    sys.exit("ERROR: No LLM API key found. Set GEMINI_API_KEY or OPENAI_API_KEY.")


def load_style(style_name):
    """Load conversation style preset from bundled YAML."""
    styles_path = Path(__file__).parent.parent / "references" / "conversation_styles.yaml"
    try:
        styles = yaml.safe_load(styles_path.read_text())
    except FileNotFoundError:
        print("WARNING: conversation_styles.yaml not found, using Podcastfy defaults.", file=sys.stderr)
        return {}
    if style_name not in styles:
        sys.exit(f"ERROR: Unknown style '{style_name}'. Available: {', '.join(styles)}")
    return styles[style_name]


def main():
    parser = argparse.ArgumentParser(description="Generate podcast MP3 from URL, text, or topic")
    parser.add_argument("--input", required=True, help="URL, text content, or topic string")
    parser.add_argument("--input-type", choices=["url", "text", "topic"], default="url")
    parser.add_argument("--style", default="deep-dive", help="deep-dive (default) | casual | news-brief")
    parser.add_argument("--tts-model", default="edge", help="edge (free/default) | openai | elevenlabs | gemini")
    parser.add_argument("--language", default=None, help="Language code: en, zh, ja, ...")
    parser.add_argument("--output-dir", default=".", help="Output directory (default: cwd)")
    args = parser.parse_args()

    from podcastfy.client import generate_podcast

    llm_config = detect_llm()
    conversation_config = load_style(args.style)

    # Edge TTS voices are locale-specific; map language → voices so non-English works.
    EDGE_VOICES = {
        "zh": ("zh-TW-HsiaoChenNeural", "zh-TW-YunJheNeural"),   # 繁體中文為唯一中文選項
        "zh-tw": ("zh-TW-HsiaoChenNeural", "zh-TW-YunJheNeural"),
        "ja": ("ja-JP-NanamiNeural", "ja-JP-KeitaNeural"),
        "ko": ("ko-KR-SunHiNeural", "ko-KR-InJoonNeural"),
        "fr": ("fr-FR-DeniseNeural", "fr-FR-HenriNeural"),
        "de": ("de-DE-KatjaNeural", "de-DE-ConradNeural"),
        "es": ("es-ES-ElviraNeural", "es-ES-AlvaroNeural"),
        "pt": ("pt-BR-FranciscaNeural", "pt-BR-AntonioNeural"),
    }

    if args.language:
        conversation_config["output_language"] = args.language
        if args.tts_model == "edge":
            lang_key = args.language.lower()
            voices = EDGE_VOICES.get(lang_key) or EDGE_VOICES.get(lang_key.split("-")[0])
            if voices:
                conversation_config.setdefault("text_to_speech", {})
                conversation_config["text_to_speech"]["edge"] = {
                    "default_voices": {"question": voices[0], "answer": voices[1]}
                }

    output_dir = Path(args.output_dir).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)
    conversation_config.setdefault("text_to_speech", {})
    conversation_config["text_to_speech"]["output_directories"] = {
        "transcripts": str(output_dir / ".podcastfy_transcripts"),
        "audio": str(output_dir),
    }

    kwargs = {
        "tts_model": args.tts_model,
        "conversation_config": conversation_config,
        **llm_config,
    }
    kwargs[{"url": "urls", "text": "text", "topic": "topic"}[args.input_type]] = (
        [args.input] if args.input_type == "url" else args.input
    )

    print(f"🎙️  Generating podcast ({args.style} / {args.tts_model} TTS)...", file=sys.stderr)
    result = generate_podcast(**kwargs)

    if not result:
        sys.exit("ERROR: Podcast generation failed.")

    result_path = Path(result)
    dest = output_dir / result_path.name
    if result_path != dest:
        shutil.move(result_path, dest)
    print(dest)


if __name__ == "__main__":
    main()

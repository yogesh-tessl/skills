# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains custom skills for Claude Code. Skills are folders of instructions, scripts, and resources that Claude loads dynamically to perform specialized tasks. Each skill is self-contained with a `SKILL.md` file as the entry point.

## Repository Structure

```
skills/
├── document-to-markdown/   # Document/URL to Markdown converter
│   ├── SKILL.md            # Skill instructions (entry point)
│   ├── CLAUDE.md           # Skill-specific development guide
│   ├── scripts/            # Python conversion scripts
│   │   ├── gateway.py      # Main entry point, routing, batch processing
│   │   ├── convert_pdf.py  # PDF backends (pymupdf4llm, marker, paddleocr)
│   │   ├── convert_image.py # OCR backends (tesseract, surya, easyocr)
│   │   └── convert_paddle.py # PaddleOCR module
│   └── references/         # Backend and troubleshooting docs
│
└── excalidraw/             # Diagram creation skill
    ├── SKILL.md            # Main skill instructions
    ├── ELEMENTS.md         # Element type reference
    ├── PALETTES.md         # Color palette definitions
    ├── STYLES.md           # Visual style guide
    ├── LIBRARIES.md        # Component library reference
    ├── IT-DIAGRAMS.md      # IT diagram templates
    ├── TEMPLATES.md        # General templates
    ├── libraries/          # 27+ pre-downloaded .excalidrawlib files
    └── examples/           # Example diagrams
```

## Skill Architecture

### How Skills Work

1. Each skill folder contains `SKILL.md` with metadata header and instructions
2. Skills are installed to `~/.claude/skills/` for Claude Code to discover
3. Claude loads skill instructions dynamically based on task context
4. Skills may include scripts, references, and resources

### SKILL.md Format

```yaml
---
name: skill-name
description: Trigger phrases and use cases
license: License info
compatibility: Platform requirements
metadata:
  version: "x.y.z"
---

# Instructions for Claude
```

## Development Commands

### document-to-markdown

```bash
# Install dependencies
pip install -r document-to-markdown/requirements.txt

# Run single file conversion
python document-to-markdown/scripts/gateway.py --input <file> --json

# Batch processing
python document-to-markdown/scripts/gateway.py --input-dir <folder> --output-dir <out> --parallel 4

# Test with specific backend
python document-to-markdown/scripts/gateway.py --input doc.pdf --pdf-backend paddleocr
```

### excalidraw

No build/test commands - this skill is instruction-only. The `.excalidrawlib` files in `libraries/` are component libraries for diagram creation.

## Key Design Patterns

### document-to-markdown

- **Gateway pattern**: `gateway.py` routes by file extension to appropriate converter
- **Backend fallback**: PDF tries pymupdf4llm → marker → markitdown
- **Two output formats**: `human` (clean) vs `rag` (structured for LLM)
- **JSON output mode**: Returns `{success, output_path, backend_used, warnings}` for agent integration

### excalidraw

- **Subagent delegation**: Main agents must NEVER read .excalidraw files directly due to token cost (4,000-22,000+ tokens per file). Always delegate to subagent and receive text summaries.
- **Library-first approach**: Use pre-built components from `libraries/` before creating custom shapes. Available libraries include AWS, Azure, GCP, Kubernetes, database, flowchart, network topology, DevOps icons, and more (27+ libraries).
- **Reference documentation**: Each aspect has its own reference file:
  - `ELEMENTS.md` - Element types (rectangle, ellipse, arrow, text, etc.)
  - `PALETTES.md` - Color palettes (dark-tech, cybersecurity, cloud-blue, corporate, etc.)
  - `STYLES.md` - Visual styles (hand-drawn, minimalist, blueprint, etc.)
  - `LIBRARIES.md` - Component library reference and usage
  - `IT-DIAGRAMS.md` - Templates for system architecture, microservices, ER diagrams
  - `TEMPLATES.md` - General purpose diagram templates
- **Quality standards**: 60-30-10 color rule, 20px grid alignment, WCAG AA contrast (≥4.5:1)

## Installation

Skills are installed via skills-cli or manual copy:

```bash
# Via skills-cli
pip install git+https://github.com/kcchien/skills-cli.git
skills-cli install --repo https://github.com/kcchien/skills --skills document-to-markdown
skills-cli install --repo https://github.com/kcchien/skills --skills excalidraw

# Manual
cp -r skills/document-to-markdown ~/.claude/skills/
cp -r skills/excalidraw ~/.claude/skills/
```

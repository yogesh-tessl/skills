# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains custom skills for Claude Code. Skills are folders of instructions, scripts, and resources that Claude loads dynamically to perform specialized tasks. Each skill is self-contained with a `SKILL.md` file as the entry point.

## Repository Structure

```
skills/                          ← git repo root
├── packages/                    ← all skill folders (symlink target)
│   ├── .system/                 ← system-level tools (hidden)
│   │   ├── skill-creator/
│   │   └── skill-installer/
│   ├── agent-browser/
│   ├── aipoint-brand-guide/
│   ├── docx/
│   ├── document-to-markdown/
│   │   ├── SKILL.md
│   │   ├── CLAUDE.md
│   │   ├── scripts/
│   │   └── references/
│   ├── excalidraw/
│   │   ├── SKILL.md
│   │   ├── libraries/
│   │   └── examples/
│   ├── frontend-design/
│   ├── model-thinking/
│   ├── clawpilot/
│   │   ├── SKILL.md
│   │   ├── scripts/
│   │   └── references/
│   ├── obsidian-vault-manager/
│   ├── pdf/
│   ├── planning-with-files/
│   ├── quality-check/
│   ├── remotion-best-practices/
│   ├── skill-creator/
│   ├── smart-water-treatment/
│   │   ├── SKILL.md
│   │   └── references/
│   ├── theme-factory/
│   ├── tsmc-research-notes/
│   ├── ui-ux-pro-max/
│   ├── vscode-extension-uiux/
│   ├── web-design-guidelines/
│   ├── xlsx/
│   └── zeabur/
├── screenshots/
├── install.sh
├── CLAUDE.md
├── README.md
└── .gitignore
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
pip install -r packages/document-to-markdown/requirements.txt

# Run single file conversion
python packages/document-to-markdown/scripts/gateway.py --input <file> --json

# Batch processing
python packages/document-to-markdown/scripts/gateway.py --input-dir <folder> --output-dir <out> --parallel 4

# Test with specific backend
python packages/document-to-markdown/scripts/gateway.py --input doc.pdf --pdf-backend paddleocr
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

### smart-water-treatment

Knowledge-only skill (no scripts). Uses progressive disclosure: lean SKILL.md with six-dimension summary table, detailed framework in `references/framework.md`, and 10 domain-specific reference files loaded on demand.

- **Design pattern**: Compact SKILL.md (~97 lines) with workflow + response modes; all domain detail in `references/`
- **Key invariants**: Physics-first verification, AI-over-PID (never bypass), fit-for-purpose design, operator-centered delivery

## Installation

Skills are installed via skills-cli or manual copy:

```bash
# Via skills-cli
pip install git+https://github.com/kcchien/skills-cli.git
skills-cli install --repo https://github.com/kcchien/skills --skills document-to-markdown
skills-cli install --repo https://github.com/kcchien/skills --skills excalidraw
skills-cli install --repo https://github.com/kcchien/skills --skills smart-water-treatment

# Manual (symlink approach)
bash skills/install.sh

# Or copy individual skills
cp -r skills/packages/document-to-markdown ~/.claude/skills/
cp -r skills/packages/excalidraw ~/.claude/skills/
cp -r skills/packages/smart-water-treatment ~/.claude/skills/
```

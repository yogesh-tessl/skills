# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A Claude Code skill for converting documents (PDF, Office, images, HTML, URLs) to clean Markdown. Designed for LLM/RAG pipelines and text extraction workflows.

## Commands

```bash
# Install dependencies (run before first use)
pip install -r requirements.txt

# Single file conversion
python scripts/gateway.py --input <file_or_url> [--json]

# Batch processing
python scripts/gateway.py --input-dir <folder> --output-dir <out> [--recursive] [--parallel 4]

# Convert with specific backend
python scripts/gateway.py --input doc.pdf --pdf-backend marker  # for scanned PDFs
python scripts/gateway.py --input image.png --ocr-backend tesseract --lang chi_tra

# Output to stdout
python scripts/gateway.py --input doc.pdf --output -
```

## Auto-Install Dependencies

When using optional backends, check and install dependencies automatically:

```bash
# Before using --pdf-backend paddleocr or --ocr-backend paddleocr
python -c "import paddleocr" 2>/dev/null || (brew install poppler && pip install paddlepaddle paddleocr pdf2image lxml prettytable)

# Before using --table-mode
python -c "from paddleocr import PPStructureV3" 2>/dev/null || pip install "paddlex[ocr]"

# Before using --to-traditional
python -c "import opencc" 2>/dev/null || pip install opencc-python-reimplemented
```

Run these checks before conversion if the user requests these features. Do not prompt - install silently if missing.

## Architecture

```
scripts/
├── gateway.py       # Main entry point, file type routing, batch processing
├── convert_pdf.py   # PDF backends: pymupdf4llm (default), marker, markitdown, paddleocr
├── convert_image.py # OCR backends: tesseract (default), surya, easyocr, paddleocr
└── convert_paddle.py # PaddleOCR module (scanned PDFs, Chinese, tables)
```

**gateway.py** handles:
- File type detection via extension
- URL conversion using Jina Reader API (with curl)
- Office/HTML conversion via MarkItDown
- Markdown cleanup and table detection/fixing
- Output format modes: `human` (simplified) vs `rag` (structured)
- Batch processing with parallel workers

**Backend fallback logic:**
- PDF: pymupdf4llm → marker (if content <100 chars) → markitdown
- Image: tesseract → surya → easyocr
- URL: Jina Reader → markitdown

## Key Options

| Option | Purpose |
|--------|---------|
| `--format human/rag` | Output style (human=clean, rag=structured for LLM) |
| `--json` | JSON output for agent integration |
| `--pdf-backend marker` | For scanned PDFs (slow, 1.3GB models) |
| `--pdf-backend paddleocr` | For scanned PDFs + Chinese (fast, <10MB) |
| `--table-mode` | Table recognition with PPStructureV3 |
| `--use-gpu` | GPU acceleration for PaddleOCR |
| `--to-traditional` | Simplified to Traditional Chinese |
| `--pages 1-10` | Convert specific PDF pages |
| `--frontmatter` | Add YAML metadata header |
| `--no-cleanup` | Disable auto table fixing |

## JSON Output Structure

```json
{"success": true, "output_path": "doc.md", "backend_used": "pymupdf4llm", "warnings": []}
```

Check `warnings` array for issues like "Complex tables detected" or empty output.

## Optional Dependencies

```bash
# For scanned PDFs - Option 1: Marker (slow, 1.3GB models)
pip install marker-pdf

# For scanned PDFs - Option 2: PaddleOCR (fast, <10MB, better Chinese)
brew install poppler
pip install paddlepaddle paddleocr pdf2image lxml prettytable
pip install opencc-python-reimplemented  # For Simplified→Traditional
pip install "paddlex[ocr]"  # For table mode (--table-mode)

# For image OCR
brew install tesseract && pip install pytesseract
pip install easyocr
```

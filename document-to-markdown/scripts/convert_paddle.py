#!/usr/bin/env python3
"""
PaddleOCR conversion module for PDF and image files.

Based on imagepdf2txt (https://github.com/joshhu/imagepdf2txt)
Supports:
- PDF to Markdown using PaddleOCR
- Table recognition with PPStructureV3
- Simplified to Traditional Chinese conversion (OpenCC)
- GPU acceleration
"""

import sys
from pathlib import Path
from typing import Optional, List, Tuple


def log_info(message: str):
    """Print info message to stderr."""
    print(f"[PaddleOCR] {message}", file=sys.stderr)


def log_warning(message: str):
    """Print warning message to stderr."""
    print(f"Warning: {message}", file=sys.stderr)


def pdf_to_images(pdf_path: Path, dpi: int = 300) -> list:
    """
    Convert PDF to list of PIL Image objects.

    Args:
        pdf_path: Path to PDF file
        dpi: Resolution for conversion (default: 300)

    Returns:
        List of PIL Image objects
    """
    try:
        from pdf2image import convert_from_path
    except ImportError as e:
        raise ImportError(
            "pdf2image is not installed.\n"
            "Install with:\n"
            "  brew install poppler\n"
            "  pip install pdf2image"
        ) from e

    log_info(f"Converting PDF to images (DPI: {dpi})...")
    try:
        images = convert_from_path(str(pdf_path), dpi=dpi)
    except Exception as e:
        if "poppler" in str(e).lower() or "pdftoppm" in str(e).lower():
            raise RuntimeError(
                "poppler is not installed (required for PDF conversion).\n"
                "Install with: brew install poppler"
            ) from e
        raise

    log_info(f"Converted {len(images)} pages")
    return images


def extract_text_with_positions(result) -> List[Tuple]:
    """
    Extract text and position info from PaddleOCR result.

    Args:
        result: PaddleOCR recognition result

    Returns:
        List of (text, y_min, y_max, x_min) tuples
    """
    text_items = []

    for res in result:
        if 'dt_polys' in res and 'rec_texts' in res:
            dt_polys = res['dt_polys']
            rec_texts = res['rec_texts']
            for poly, text in zip(dt_polys, rec_texts):
                if text.strip():
                    y_coords = [p[1] for p in poly]
                    x_coords = [p[0] for p in poly]
                    y_min = min(y_coords)
                    y_max = max(y_coords)
                    x_min = min(x_coords)
                    text_items.append((text, y_min, y_max, x_min))

    return text_items


def group_into_paragraphs(
    text_items: List[Tuple],
    line_threshold: float = 0.5,
    para_threshold: float = 1.5
) -> str:
    """
    Group text items into paragraphs based on position.

    Args:
        text_items: List of (text, y_min, y_max, x_min) tuples
        line_threshold: Y tolerance for same line (relative to line height)
        para_threshold: Y gap for new paragraph (relative to line height)

    Returns:
        Text with paragraph structure preserved
    """
    if not text_items:
        return ""

    # Sort by Y coordinate (top to bottom), then X (left to right)
    sorted_items = sorted(text_items, key=lambda x: (x[1], x[3]))

    # Calculate average line height
    avg_line_height = sum(item[2] - item[1] for item in sorted_items) / len(sorted_items)

    paragraphs = []
    current_line = []
    current_line_y = None
    prev_line_y_max = None

    for text, y_min, y_max, x_min in sorted_items:
        if current_line_y is None:
            current_line = [text]
            current_line_y = y_min
            prev_line_y_max = y_max
        elif abs(y_min - current_line_y) < avg_line_height * line_threshold:
            # Same line
            current_line.append(text)
        else:
            # New line
            line_text = "".join(current_line)
            gap = y_min - prev_line_y_max
            is_new_paragraph = gap > avg_line_height * para_threshold

            if is_new_paragraph and paragraphs:
                paragraphs.append("")

            paragraphs.append(line_text)
            current_line = [text]
            current_line_y = y_min
            prev_line_y_max = y_max

    # Handle last line
    if current_line:
        paragraphs.append("".join(current_line))

    return "\n".join(paragraphs)


def html_table_to_ascii(html_str: str) -> str:
    """
    Convert HTML table to ASCII table format.

    Args:
        html_str: HTML table string

    Returns:
        ASCII formatted table
    """
    from prettytable import PrettyTable
    from lxml import etree

    def get_text(element):
        return ''.join(element.itertext()).strip()

    try:
        root = etree.HTML(html_str)
        tables = root.xpath('//table')
        if not tables:
            return html_str

        result = []
        for table in tables:
            pt = PrettyTable()
            pt.header = False

            rows = table.xpath('.//tr')
            max_cols = 0
            all_rows = []

            for row in rows:
                cells = row.xpath('.//td|.//th')
                row_data = [get_text(cell) for cell in cells]
                if row_data:
                    all_rows.append(row_data)
                    max_cols = max(max_cols, len(row_data))

            if all_rows and max_cols > 0:
                pt.field_names = [f'col{i}' for i in range(max_cols)]
                for row_data in all_rows:
                    while len(row_data) < max_cols:
                        row_data.append('')
                    pt.add_row(row_data[:max_cols])
                result.append(pt.get_string())

        return '\n\n'.join(result) if result else html_str
    except Exception as e:
        return f'[Table parse error: {e}]'


def ocr_images(
    images: list,
    ocr_engine,
    preserve_paragraphs: bool = True,
    para_threshold: float = 1.5
) -> List[str]:
    """
    Perform OCR on list of images.

    Args:
        images: List of PIL Image objects
        ocr_engine: PaddleOCR engine instance
        preserve_paragraphs: Whether to preserve paragraph structure
        para_threshold: Paragraph gap threshold

    Returns:
        List of text for each page
    """
    import numpy as np

    all_text = []

    for i, image in enumerate(images, 1):
        log_info(f"OCR page {i}/{len(images)}...")

        image_array = np.array(image)
        result = ocr_engine.predict(image_array)

        if preserve_paragraphs:
            text_items = extract_text_with_positions(result)
            page_text = group_into_paragraphs(text_items, para_threshold=para_threshold)
        else:
            page_text = []
            for res in result:
                if 'rec_texts' in res and res['rec_texts']:
                    page_text.extend(res['rec_texts'])
            page_text = "\n".join(page_text)

        all_text.append(page_text)

    return all_text


def structure_ocr_images(images: list, pipeline) -> List[str]:
    """
    Perform structured OCR with table recognition.

    Args:
        images: List of PIL Image objects
        pipeline: PPStructureV3 pipeline instance

    Returns:
        List of text for each page (tables in ASCII format)
    """
    import numpy as np

    all_text = []

    for i, image in enumerate(images, 1):
        log_info(f"Structured OCR page {i}/{len(images)}...")

        image_array = np.array(image)
        result = pipeline.predict(image_array)

        if not result:
            all_text.append("")
            continue

        res = result[0]
        page_parts = []

        # Extract from parsing_res_list
        if 'parsing_res_list' in res:
            for block in res['parsing_res_list']:
                block_label = getattr(block, 'label', '')
                block_content = getattr(block, 'content', '') or ''

                if block_label == 'table':
                    if block_content and '<table' in block_content.lower():
                        ascii_table = html_table_to_ascii(block_content)
                        page_parts.append(ascii_table)
                    elif block_content:
                        page_parts.append(block_content.strip())
                else:
                    if block_content and block_content.strip():
                        page_parts.append(block_content.strip())

        # Fallback to table_res_list
        if not page_parts and 'table_res_list' in res:
            for table in res['table_res_list']:
                if hasattr(table, 'pred_html'):
                    ascii_table = html_table_to_ascii(table.pred_html)
                    page_parts.append(ascii_table)
                elif isinstance(table, dict) and 'pred_html' in table:
                    ascii_table = html_table_to_ascii(table['pred_html'])
                    page_parts.append(ascii_table)

        # Fallback to overall_ocr_res
        if not page_parts and 'overall_ocr_res' in res:
            ocr_res = res['overall_ocr_res']
            if 'rec_texts' in ocr_res:
                page_parts.extend(ocr_res['rec_texts'])

        all_text.append('\n\n'.join(page_parts))

    return all_text


def convert_to_traditional(text: str) -> str:
    """
    Convert Simplified Chinese to Traditional Chinese (Taiwan).

    Args:
        text: Input text (may contain Simplified Chinese)

    Returns:
        Text converted to Traditional Chinese with Taiwan terms
    """
    try:
        import opencc
        converter = opencc.OpenCC('s2twp')  # Simplified to Traditional (Taiwan)
        return converter.convert(text)
    except ImportError:
        log_warning("OpenCC not installed. Run: pip install opencc-python-reimplemented")
        return text


def format_as_markdown(pages: List[str], add_page_markers: bool = True) -> str:
    """
    Format OCR output as Markdown.

    Args:
        pages: List of text for each page
        add_page_markers: Whether to add page separators

    Returns:
        Markdown formatted text
    """
    if not pages:
        return ""

    if len(pages) == 1:
        return pages[0].strip() + "\n"

    result = []
    for i, page_text in enumerate(pages, 1):
        if add_page_markers and i > 1:
            result.append(f"\n---\n\n<!-- Page {i} -->\n")
        result.append(page_text.strip())

    return "\n\n".join(result) + "\n"


def convert_with_paddleocr(
    file_path: Path,
    use_gpu: bool = False,
    table_mode: bool = False,
    to_traditional: bool = False,
    dpi: int = 300,
    lang: str = "ch",
    preserve_paragraphs: bool = True,
    para_threshold: float = 1.5,
    **kwargs
) -> Tuple[str, str]:
    """
    Convert PDF or image to Markdown using PaddleOCR.

    Args:
        file_path: Path to PDF or image file
        use_gpu: Use GPU acceleration
        table_mode: Enable table recognition (PPStructureV3)
        to_traditional: Convert Simplified to Traditional Chinese
        dpi: DPI for PDF to image conversion
        lang: OCR language (ch, en, japan, etc.)
        preserve_paragraphs: Preserve paragraph structure
        para_threshold: Paragraph gap threshold

    Returns:
        Tuple of (markdown_content, backend_name)
    """
    file_path = Path(file_path)
    device = "gpu" if use_gpu else "cpu"

    # Determine if input is PDF or image
    is_pdf = file_path.suffix.lower() == ".pdf"

    if is_pdf:
        images = pdf_to_images(file_path, dpi=dpi)
    else:
        # Single image
        from PIL import Image
        images = [Image.open(file_path)]

    # Initialize engine
    if table_mode:
        try:
            from paddleocr import PPStructureV3
        except ImportError as e:
            if "paddlex" in str(e).lower() or "ppstructure" in str(e).lower():
                raise ImportError(
                    "Table mode requires additional dependencies.\n"
                    "Install with: pip install \"paddlex[ocr]\"\n"
                    "This will download ~200MB of models on first use."
                ) from e
            raise

        log_info(f"Initializing PPStructureV3 ({device})...")
        try:
            engine = PPStructureV3(
                device=device,
                use_doc_orientation_classify=False,
                use_doc_unwarping=False,
                use_table_recognition=True,
                lang=lang,
            )
        except Exception as e:
            if "pipeline" in str(e).lower() or "dependency" in str(e).lower():
                raise ImportError(
                    "Table mode initialization failed. Missing dependencies.\n"
                    "Install with: pip install \"paddlex[ocr]\"\n"
                    "This will download ~200MB of models on first use."
                ) from e
            raise

        texts = structure_ocr_images(images, engine)
        backend_name = "paddleocr-ppstructure"
    else:
        try:
            from paddleocr import PaddleOCR
        except ImportError as e:
            raise ImportError(
                "PaddleOCR is not installed.\n"
                "Install with:\n"
                "  brew install poppler\n"
                "  pip install paddlepaddle paddleocr pdf2image lxml prettytable"
            ) from e

        log_info(f"Initializing PaddleOCR ({device})...")
        engine = PaddleOCR(
            device=device,
            use_doc_orientation_classify=False,
            use_doc_unwarping=False,
            use_textline_orientation=False,
            lang=lang,
        )
        texts = ocr_images(
            images,
            engine,
            preserve_paragraphs=preserve_paragraphs,
            para_threshold=para_threshold
        )
        backend_name = "paddleocr"

    # Format as markdown
    markdown = format_as_markdown(texts, add_page_markers=is_pdf and len(texts) > 1)

    # Convert to Traditional Chinese if requested
    if to_traditional:
        log_info("Converting to Traditional Chinese...")
        markdown = convert_to_traditional(markdown)

    return markdown, backend_name


def ocr_single_image(
    image_path: Path,
    use_gpu: bool = False,
    to_traditional: bool = False,
    lang: str = "ch",
    **kwargs
) -> str:
    """
    OCR a single image file.

    Args:
        image_path: Path to image file
        use_gpu: Use GPU acceleration
        to_traditional: Convert to Traditional Chinese
        lang: OCR language

    Returns:
        Extracted text
    """
    # Filter out parameters that are explicitly set
    filtered_kwargs = {k: v for k, v in kwargs.items()
                       if k not in ('use_gpu', 'table_mode', 'to_traditional', 'lang')}

    content, _ = convert_with_paddleocr(
        image_path,
        use_gpu=use_gpu,
        table_mode=False,  # Table mode not supported for single images
        to_traditional=to_traditional,
        lang=lang,
        **filtered_kwargs
    )
    return content


def main():
    """CLI entry point for testing."""
    import argparse

    parser = argparse.ArgumentParser(description="PaddleOCR conversion")
    parser.add_argument("input", type=Path, help="Input PDF or image file")
    parser.add_argument("-o", "--output", type=Path, help="Output file")
    parser.add_argument("--gpu", action="store_true", help="Use GPU")
    parser.add_argument("--table", action="store_true", help="Enable table mode")
    parser.add_argument("--traditional", action="store_true", help="Convert to Traditional Chinese")
    parser.add_argument("--dpi", type=int, default=300, help="DPI (default: 300)")
    parser.add_argument("--lang", default="ch", help="Language (default: ch)")

    args = parser.parse_args()

    if not args.input.exists():
        print(f"Error: File not found: {args.input}", file=sys.stderr)
        return 1

    try:
        content, backend = convert_with_paddleocr(
            args.input,
            use_gpu=args.gpu,
            table_mode=args.table,
            to_traditional=args.traditional,
            dpi=args.dpi,
            lang=args.lang,
        )

        if args.output:
            args.output.write_text(content, encoding="utf-8")
            print(f"Saved to: {args.output} (backend: {backend})")
        else:
            print(content)

        return 0
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())

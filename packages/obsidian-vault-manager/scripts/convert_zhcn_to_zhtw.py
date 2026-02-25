#!/usr/bin/env python3
"""簡體中文轉繁體中文（台灣用語）轉換腳本。

基於 opencc-python-reimplemented，跨平台（macOS / Linux / Windows）。
首次執行時若缺少依賴會自動安裝。
預設使用 s2twp 設定檔（含台灣慣用詞彙轉換，如 软件→軟體、内存→記憶體）。
預設自動保護 YAML frontmatter 不被轉換。

用法：
  python3 convert_zhcn_to_zhtw.py <file.md> [file2.md ...]
  python3 convert_zhcn_to_zhtw.py --dir <folder_path>
  python3 convert_zhcn_to_zhtw.py --dry-run <file.md>
  python3 convert_zhcn_to_zhtw.py --backup <file.md>
  python3 convert_zhcn_to_zhtw.py --include-frontmatter <file.md>
  python3 convert_zhcn_to_zhtw.py --config s2tw <file.md>
"""

import argparse
import difflib
import shutil
import subprocess
import sys
from pathlib import Path


def ensure_opencc():
    """確認 opencc-python-reimplemented 已安裝，否則自動安裝。"""
    try:
        from opencc import OpenCC  # noqa: F401
        return
    except ImportError:
        pass

    print("正在自動安裝 opencc-python-reimplemented ...", file=sys.stderr)

    pkg = "opencc-python-reimplemented==0.1.7"

    # 依序嘗試 uv → pip
    for cmd in (
        [shutil.which("uv"), "pip", "install", pkg],
        [sys.executable, "-m", "pip", "install", pkg],
    ):
        if cmd[0] is None:
            continue
        try:
            subprocess.check_call(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            # 安裝後再次確認
            from opencc import OpenCC  # noqa: F401
            print("安裝完成。", file=sys.stderr)
            return
        except (subprocess.CalledProcessError, ImportError):
            continue

    print("錯誤：無法自動安裝 opencc-python-reimplemented。", file=sys.stderr)
    print("請手動執行：pip install opencc-python-reimplemented", file=sys.stderr)
    sys.exit(1)


def convert_text(text: str, config: str) -> str:
    """使用 OpenCC 轉換文字。"""
    from opencc import OpenCC
    cc = OpenCC(config)
    return cc.convert(text)


def split_frontmatter(content: str) -> tuple[str | None, str]:
    """拆分 YAML frontmatter 與正文。

    回傳 (frontmatter_including_delimiters, body)。
    若無 frontmatter 則回傳 (None, original_content)。
    """
    if not content.startswith("---\n") and not content.startswith("---\r\n"):
        return None, content

    # 找第二個 ---
    search_start = content.index("\n") + 1
    end_markers = ["---\n", "---\r\n"]
    for marker in end_markers:
        pos = content.find(marker, search_start)
        if pos != -1:
            fm_end = pos + len(marker)
            return content[:fm_end], content[fm_end:]

    # 檔案尾端的 ---（無換行）
    if content.rstrip().endswith("---") and content.count("---") >= 2:
        last_pos = content.rindex("---", search_start)
        return content[:last_pos + 3], content[last_pos + 3:]

    return None, content


def convert_file(filepath: Path, config: str, protect_frontmatter: bool) -> str:
    """轉換單一檔案內容，回傳轉換後的文字。"""
    content = filepath.read_text(encoding="utf-8")

    if protect_frontmatter:
        fm, body = split_frontmatter(content)
        converted_body = convert_text(body, config)
        if fm is not None:
            return fm + converted_body
        return converted_body
    else:
        return convert_text(content, config)


def show_diff(filepath: Path, original: str, converted: str, max_lines: int = 50):
    """顯示差異預覽。"""
    all_lines = list(difflib.unified_diff(
        original.splitlines(keepends=True),
        converted.splitlines(keepends=True),
        fromfile=str(filepath),
        tofile=str(filepath) + " (converted)",
        n=1,
    ))
    lines = all_lines[:max_lines]
    if lines:
        print(f"--- 差異預覽：{filepath} ---")
        sys.stdout.writelines(lines)
        if len(all_lines) > max_lines:
            print(f"\n... (僅顯示前 {max_lines} 行，共 {len(all_lines)} 行)")
        print()


def collect_files(args) -> list[Path]:
    """根據參數收集要處理的檔案。"""
    files: list[Path] = []

    if args.dir:
        dir_path = Path(args.dir)
        if not dir_path.is_dir():
            print(f"錯誤：資料夾不存在：{dir_path}", file=sys.stderr)
            sys.exit(1)
        files.extend(sorted(dir_path.rglob("*.md")))

    for f in (args.files or []):
        files.append(Path(f))

    return files


def main():
    parser = argparse.ArgumentParser(
        description="簡體中文轉繁體中文（台灣用語）轉換工具",
    )
    parser.add_argument("files", nargs="*", help="要轉換的 .md 檔案")
    parser.add_argument("--dir", help="遞迴處理資料夾中所有 .md 檔案")
    parser.add_argument("--dry-run", action="store_true", help="只顯示差異，不實際修改")
    parser.add_argument("--backup", action="store_true", default=True,
                        help="修改前建立 .bak 備份（預設啟用）")
    parser.add_argument("--no-backup", action="store_true",
                        help="不建立 .bak 備份")
    parser.add_argument("--include-frontmatter", action="store_true",
                        help="連同 YAML frontmatter 一起轉換（預設會跳過）")
    parser.add_argument("--config", default="s2twp",
                        choices=["s2twp", "s2tw", "s2t", "s2hk", "t2s", "tw2s", "tw2sp"],
                        help="OpenCC 設定檔（預設：s2twp）")
    args = parser.parse_args()

    files = collect_files(args)
    if not files:
        parser.print_help()
        print("\n可用設定檔：")
        print("  s2twp  簡體→繁體台灣（含詞彙轉換，推薦）")
        print("  s2tw   簡體→繁體台灣（僅字元轉換）")
        print("  s2t    簡體→繁體（通用）")
        print("  s2hk   簡體→繁體香港")
        print("  t2s    繁體→簡體")
        print("  tw2s   繁體台灣→簡體")
        sys.exit(0)

    # 確保依賴已安裝（在實際需要轉換前才檢查，避免 --help 時觸發安裝）
    ensure_opencc()

    converted_count = 0
    skipped_count = 0
    error_count = 0
    protect_fm = not args.include_frontmatter

    for filepath in files:
        if not filepath.is_file():
            print(f"跳過（不存在）：{filepath}")
            skipped_count += 1
            continue

        try:
            original = filepath.read_text(encoding="utf-8")
            result = convert_file(filepath, args.config, protect_fm)
        except Exception as e:
            print(f"錯誤（轉換失敗）：{filepath} — {e}")
            error_count += 1
            continue

        if original == result:
            print(f"跳過（無需轉換）：{filepath}")
            skipped_count += 1
            continue

        if args.dry_run:
            show_diff(filepath, original, result)
            converted_count += 1
            continue

        if args.backup and not args.no_backup:
            backup_path = filepath.with_suffix(filepath.suffix + ".bak")
            shutil.copy2(filepath, backup_path)

        filepath.write_text(result, encoding="utf-8")
        print(f"已轉換：{filepath}")
        converted_count += 1

    print()
    print("=== 完成 ===")
    label = "需轉換" if args.dry_run else "已轉換"
    print(f"{label}：{converted_count} 個檔案")
    print(f"已跳過：{skipped_count} 個檔案")
    if error_count > 0:
        print(f"錯誤：  {error_count} 個檔案")


if __name__ == "__main__":
    main()

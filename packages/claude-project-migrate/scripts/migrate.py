#!/usr/bin/env python3
"""
Claude Code project data migration tool.

Migrates ~/.claude/projects/<encoded-path>/ data when a project directory
is moved or renamed. Uses the same path encoding as Claude Code's HK() function.

Usage:
    python3 migrate.py <source-path> <dest-path> [--dry-run] [--no-project-files]
"""

import argparse
import os
import re
import shutil
import sys

CLAUDE_PROJECTS = os.path.expanduser("~/.claude/projects")
ICLOUD_MARKER = os.path.join("Mobile Documents", "com~apple~CloudDocs")


def _djb2_base36(text: str) -> str:
    """DJB2 hash -> base-36 string, matching Claude Code's JS implementation."""
    h = 5381
    for ch in text:
        h = ((h << 5) + h + ord(ch)) & 0xFFFFFFFF
    if h == 0:
        return "0"
    digits = "0123456789abcdefghijklmnopqrstuvwxyz"
    result = []
    while h:
        result.append(digits[h % 36])
        h //= 36
    return "".join(reversed(result))


def encode_project_path(path: str) -> str:
    """Encode a path the same way Claude Code does. Resolves to absolute first."""
    path = os.path.abspath(os.path.expanduser(path))
    encoded = re.sub(r"[^a-zA-Z0-9]", "-", path)
    if len(encoded) > 200:
        encoded = encoded[:200] + "-" + _djb2_base36(encoded)
    return encoded


def _repair_nosync_links(directory: str) -> None:
    """Find *.nosync dirs and fix their companion symlinks if broken."""
    for entry in os.scandir(directory):
        if not (entry.is_dir(follow_symlinks=False) and entry.name.endswith(".nosync")):
            continue
        link_name = entry.name.removesuffix(".nosync")
        link_path = os.path.join(directory, link_name)
        if os.path.islink(link_path) and not os.path.exists(link_path):
            print(f"  [FIX] Broken symlink: {link_path}")
            os.remove(link_path)
            os.symlink(entry.name, link_path)
            print(f"         Re-linked to: {entry.name}")


def migrate(src_path: str, dst_path: str, *,
            dry_run: bool = False, no_project_files: bool = False) -> bool:
    """Migrate Claude project data from src_path to dst_path.

    Returns True on success, False on failure.
    """
    src_abs = os.path.abspath(os.path.expanduser(src_path))
    dst_abs = os.path.abspath(os.path.expanduser(dst_path))

    src_encoded = encode_project_path(src_abs)
    dst_encoded = encode_project_path(dst_abs)
    src_claude = os.path.join(CLAUDE_PROJECTS, src_encoded)
    dst_claude = os.path.join(CLAUDE_PROJECTS, dst_encoded)

    mode = "[DRY RUN] " if dry_run else ""

    # --- Summary ---
    print(f"\n{'=' * 60}")
    print(f"  Claude Project Migration {mode}")
    print(f"{'=' * 60}")
    print(f"  Source project : {src_abs}")
    print(f"  Dest project   : {dst_abs}")
    print(f"  Source encoded  : {src_encoded}")
    print(f"  Dest encoded    : {dst_encoded}")
    print(f"  Claude data src : {src_claude}")
    print(f"  Claude data dst : {dst_claude}")
    print(f"  Move files      : {'no (--no-project-files)' if no_project_files else 'yes'}")
    print(f"{'=' * 60}\n")

    # --- iCloud warnings ---
    for label, p in [("Source", src_abs), ("Destination", dst_abs)]:
        if ICLOUD_MARKER in p:
            print(f"  [WARNING] {label} is inside iCloud Drive.")
            print(f"            Sync conflicts or .icloud placeholders may occur.\n")

    # --- Pre-validation ---
    errors = []
    if not no_project_files and not os.path.isdir(src_abs):
        errors.append(f"Source project directory does not exist: {src_abs}")
    if not no_project_files and os.path.exists(dst_abs):
        errors.append(f"Destination already exists: {dst_abs}")
    if not os.path.isdir(src_claude):
        errors.append(f"Claude data directory does not exist: {src_claude}")
    if errors:
        for e in errors:
            print(f"  [ERROR] {e}")
        return False

    # --- Step 1: Copy Claude data ---
    print(f"  {mode}Copying Claude data...")
    print(f"    {src_claude}\n    -> {dst_claude}")
    if not dry_run:
        if os.path.exists(dst_claude):
            print(f"  [WARNING] Destination Claude data already exists, skipping copy.")
        else:
            shutil.copytree(src_claude, dst_claude)

    # --- Step 2: Move project files ---
    if not no_project_files:
        print(f"\n  {mode}Moving project files...")
        print(f"    {src_abs}\n    -> {dst_abs}")
        if not dry_run:
            os.makedirs(os.path.dirname(dst_abs), exist_ok=True)
            shutil.move(src_abs, dst_abs)
    else:
        print(f"\n  Skipping project file move (--no-project-files)")

    # --- Step 3: Repair .nosync symlinks + post-validation ---
    if not dry_run:
        target_dir = dst_abs if not no_project_files else src_abs
        if os.path.isdir(target_dir):
            print(f"\n  Checking .nosync symlinks in {target_dir}...")
            _repair_nosync_links(target_dir)

        if not no_project_files and not os.path.isdir(dst_abs):
            print(f"  [ERROR] Destination project missing after move: {dst_abs}")
            return False
        if not os.path.isdir(dst_claude):
            print(f"  [ERROR] Claude data missing after copy: {dst_claude}")
            return False

    print(f"\n  {'[DRY RUN] Would complete' if dry_run else 'Migration complete'}.")
    print(f"  Claude data copied (original preserved at {src_claude}).")
    if not no_project_files and not dry_run:
        print(f"  Project files moved to {dst_abs}.")
    print()
    return True


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Migrate Claude Code project data when moving directories.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "Examples:\n"
            "  python3 migrate.py ~/old/project ~/new/project --dry-run\n"
            "  python3 migrate.py ~/old/project ~/new/project\n"
            "  python3 migrate.py ~/old/project ~/new/project --no-project-files\n"
        ),
    )
    parser.add_argument("source", help="Original project directory path")
    parser.add_argument("dest", help="New project directory path")
    parser.add_argument("--dry-run", action="store_true",
                        help="Preview all operations without executing")
    parser.add_argument("--no-project-files", action="store_true",
                        help="Only migrate Claude data (skip moving project files)")

    args = parser.parse_args()
    ok = migrate(args.source, args.dest,
                 dry_run=args.dry_run, no_project_files=args.no_project_files)
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()

---
name: claude-project-migrate
description: >
  Migrate Claude Code project data when moving project directories.
  Automatically encodes paths and copies conversation history, memory,
  and settings from old to new location under ~/.claude/projects/.
  Use when: (1) Moving or renaming a project directory,
  (2) User mentions "遷移專案", "移動專案", "對話紀錄遺失",
  (3) User asks about ~/.claude/projects/ encoding,
  (4) Project conversation history is missing after a directory move.
---

# Claude Project Migration

Claude Code stores per-project data in `~/.claude/projects/<encoded-path>/`.
Moving a project directory breaks this link. This skill automates the migration.

## Path Encoding Rules

1. Take the absolute path (e.g., `/Users/kc/projects/my-app`)
2. Replace every non-alphanumeric character with `-` (regex: `/[^a-zA-Z0-9]/g`)
3. Result: `-Users-kc-projects-my-app`
4. If result exceeds 200 characters: truncate to 200 chars + `-<djb2-hash-base36>`

## Migration Script

`scripts/migrate.py` — pure Python 3, no external dependencies.

```bash
# Preview (always do this first)
python3 scripts/migrate.py /old/path /new/path --dry-run

# Full migration: copy Claude data + move project files
python3 scripts/migrate.py /old/path /new/path

# Only migrate Claude data (project already moved manually)
python3 scripts/migrate.py /old/path /new/path --no-project-files
```

| Parameter | Description |
|-----------|-------------|
| `source` | Original project directory path |
| `dest` | New project directory path |
| `--dry-run` | Preview all operations without executing |
| `--no-project-files` | Only copy Claude data, skip moving project files |

### Behavior

1. **Encodes** both paths using Claude Code's algorithm
2. **Copies** Claude data to new encoded path (original preserved as backup)
3. **Moves** project files (unless `--no-project-files`)
4. **Warns** on iCloud paths (sync conflicts / `.icloud` placeholders)
5. **Repairs** broken `.nosync` symlinks after move
6. **Validates** before and after migration

### Safety

- Copy-not-move for Claude data (original preserved)
- Pre-validation: source exists, destination doesn't, Claude data exists
- Post-validation: confirms files arrived at destination

## Limitations

- Encoding matches Claude Code v2.1.61–2.1.66; may change in future versions
- The 200-char truncation + hash path is implemented but rarely triggered in practice
- `.icloud` placeholder files are detected but not automatically resolved

---
name: update-from-cursor
description: Re-sync .claude/ config from Cursor source files after Cursor rules or skills have changed. Requires /init-from-cursor to have been run first. Invoke with /update-from-cursor. Triggers on phrases like "sync cursor to claude", "update claude config", "cursor files changed", or when the user mentions Cursor rules were updated.
---

# /update-from-cursor

Re-sync `.claude/` converted files from their Cursor sources using the sync map. Never modifies Cursor files. Only affects files tracked in `.claude/cursor-sync-map.json` — symlinked items (agents, cursor skills) auto-propagate without needing this skill.

## Prerequisite

`/init-from-cursor` must have been run first. If `.claude/cursor-sync-map.json` doesn't exist, the script will tell you.

## How to run

```bash
python ~/.claude/skills/update-from-cursor/scripts/update.py /path/to/project
```

Or from inside the project directory:

```bash
python ~/.claude/skills/update-from-cursor/scripts/update.py
```

Run this command directly — do not attempt re-conversion manually.

## What it does

1. Loads `.claude/cursor-sync-map.json`
2. Reports any untracked `.mdc` files (new files added to `.cursor/` since last init)
3. For each tracked entry: re-reads source, re-applies conversion, overwrites destination only if content changed
4. Updates sync map timestamp
5. Rebuilds the Skills section of CLAUDE.md if any skill descriptions changed
6. Prints report: updated / unchanged / broken sources / untracked

## Notes

- Broken sources (source file deleted or renamed) are reported but not auto-removed from the sync map
- Untracked sources are listed but not added automatically — run `/init-from-cursor` to pick them up
- Symlinked entries (agents, cursor skill dirs) are not in the sync map and don't need updating

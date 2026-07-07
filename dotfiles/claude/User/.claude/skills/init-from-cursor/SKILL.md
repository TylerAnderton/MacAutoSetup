---
name: init-from-cursor
description: One-time bootstrap of .claude/ config from existing Cursor rules and skills. Use when setting up Claude Code on a project that already has a .cursor/ directory. Invoke with /init-from-cursor. Triggers on phrases like "set up claude from cursor", "bootstrap claude config", "convert cursor to claude", or when the user has Cursor config and wants Claude Code to use it.
---

# /init-from-cursor

Bootstrap `.claude/` from an existing `.cursor/` directory. Never modifies Cursor files.

## When to use

Run once per repo, from the project root, when:
- The project has a `.cursor/` directory with rules/skills/agents
- No `.claude/` structure exists yet (or you want to re-bootstrap it)

## How to run

Execute the bundled script, passing the project root as an argument:

```bash
python ~/.claude/skills/init-from-cursor/scripts/init.py /path/to/project
```

Or from inside the project directory:

```bash
python ~/.claude/skills/init-from-cursor/scripts/init.py
```

Run this command directly — do not attempt to perform the conversion manually. The script is deterministic and handles all classification logic.

## What it does

1. Reads `.cursor/rules` (plain routing file) for use in CLAUDE.md
2. Scans `.cursor/rules/*.mdc` (standard) and `.cursor/*.mdc` (edge case) — classifies each by frontmatter:
   - `alwaysApply: true` → `.claude/rules/<name>.md` (body only, no frontmatter)
   - `alwaysApply: false` + globs defined → `.claude/rules/<name>.md` (with `paths:` frontmatter)
   - `alwaysApply: false` + no globs → `.claude/skills/<name>/SKILL.md` (with Claude `name`/`description` frontmatter)
3. Symlinks `.cursor/agents/` entries → `.claude/agents/` (whole files and subdirs)
4. Symlinks `.cursor/skills/` directories → `.claude/skills/` (entire dirs)
5. Writes `.claude/cursor-sync-map.json` (tracks `.mdc` conversions for future updates)

## After running

- Symlinked items (agents, cursor skills) auto-propagate when Cursor files change
- Converted items (from `.mdc`) need `/update-from-cursor` to re-sync
- Report shows everything created; review it before proceeding

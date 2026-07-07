#!/usr/bin/env python3
"""
update-from-cursor: Re-sync .claude/ from .cursor/ using the sync map.

Usage:
    python update.py [project_root]

project_root defaults to the current working directory.
"""
import json
import sys
from datetime import datetime, timezone
from pathlib import Path


# ── Reuse parsing/writing logic from init.py ─────────────────────────────────

def parse_frontmatter(text):
    if not text.startswith("---"):
        return {}, text
    end = text.find("\n---", 3)
    if end == -1:
        return {}, text
    fm_block = text[3:end].strip()
    body = text[end + 4:].lstrip("\n")
    meta = {}
    for line in fm_block.splitlines():
        if ":" in line:
            key, _, val = line.partition(":")
            key = key.strip()
            val = val.strip()
            if val.lower() == "true":
                meta[key] = True
            elif val.lower() == "false":
                meta[key] = False
            elif val:
                meta[key] = val
            else:
                meta[key] = None
    return meta, body


def classify_mdc(meta):
    always_apply = meta.get("alwaysApply", False)
    globs = meta.get("globs")
    if always_apply:
        return "rule"
    if bool(globs):
        return "scoped-rule"
    return "skill"


def build_content(entry_type, meta, body, name):
    if entry_type == "rule":
        return body
    elif entry_type == "scoped-rule":
        globs = meta.get("globs")
        paths_lines = "\n".join(f"  - {g.strip()}" for g in globs.split(",")) if globs else "  - \"*\""
        return f"---\npaths:\n{paths_lines}\n---\n\n{body}"
    else:  # skill
        description = meta.get("description", f"Skill converted from Cursor: {name}")
        return f"---\nname: {name}\ndescription: {description}\n---\n\n{body}"


def find_mdc_files(cursor_dir):
    found = {}
    rules_dir = cursor_dir / "rules"
    if rules_dir.is_dir():
        for p in sorted(rules_dir.glob("*.mdc")):
            found[p.stem] = p
    for p in sorted(cursor_dir.glob("*.mdc")):
        if p.stem not in found:
            found[p.stem] = p
    return found


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    project_root = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path.cwd()
    claude_dir = project_root / ".claude"
    cursor_dir = project_root / ".cursor"
    sync_map_path = claude_dir / "cursor-sync-map.json"

    # ── Step 1: Load sync map ─────────────────────────────────────────────────
    if not sync_map_path.exists():
        print("ERROR: .claude/cursor-sync-map.json not found.")
        print("Run /init-from-cursor first to bootstrap the .claude/ config.")
        sys.exit(1)

    with open(sync_map_path) as f:
        sync_map = json.load(f)

    entries = sync_map.get("entries", [])
    tracked_sources = {e["source"] for e in entries}

    # ── Step 2: Detect untracked .mdc files ───────────────────────────────────
    all_mdc = find_mdc_files(cursor_dir)
    untracked = []
    for _stem, path in all_mdc.items():
        rel = str(path.relative_to(project_root))
        if rel not in tracked_sources:
            untracked.append(rel)

    if untracked:
        print("WARNING: Untracked Cursor files (not in sync map):")
        for u in untracked:
            print(f"  {u}")
        print("Run /init-from-cursor to add them.")
        print()

    # ── Step 3: Re-sync each tracked entry ────────────────────────────────────
    updated = []
    unchanged = []
    broken = []

    for entry in entries:
        src_path = project_root / entry["source"]
        dest_path = project_root / entry["destination"]
        entry_type = entry["type"]

        if not src_path.exists():
            broken.append(entry["source"])
            continue

        text = src_path.read_text()
        meta, body = parse_frontmatter(text)
        name = src_path.stem
        new_content = build_content(entry_type, meta, body, name)

        existing = dest_path.read_text() if dest_path.exists() else None

        if existing == new_content:
            unchanged.append(entry["destination"])
        else:
            dest_path.parent.mkdir(parents=True, exist_ok=True)
            dest_path.write_text(new_content)
            updated.append(entry["destination"])

    # ── Step 4: Update sync map timestamp ────────────────────────────────────
    sync_map["generated"] = datetime.now(timezone.utc).isoformat()
    sync_map_path.write_text(json.dumps(sync_map, indent=2))

    # ── Report ────────────────────────────────────────────────────────────────
    print("/update-from-cursor complete")
    print("─" * 50)
    print(f"Updated:               {len(updated)}")
    for p in updated:
        print(f"  {p}")
    print(f"Unchanged:             {len(unchanged)}")
    print(f"Broken sources:        {len(broken)}")
    for p in broken:
        print(f"  {p}  ← source missing")
    print(f"Untracked sources:     {len(untracked)}")
    for p in untracked:
        print(f"  {p}")
    print("─" * 50)


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
init-from-cursor: Bootstrap .claude/ from .cursor/ in a project.

Usage:
    python init.py [project_root]

project_root defaults to the current working directory.
"""
import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path


# ── Frontmatter parsing ──────────────────────────────────────────────────────

def parse_frontmatter(text):
    """Return (meta_dict, body_str). meta_dict is {} if no frontmatter."""
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
    """Return 'rule', 'scoped-rule', or 'skill' based on frontmatter."""
    always_apply = meta.get("alwaysApply", False)
    globs = meta.get("globs")
    has_globs = bool(globs)

    if always_apply:
        return "rule"
    if has_globs:
        return "scoped-rule"
    return "skill"


# ── File discovery ────────────────────────────────────────────────────────────

def find_mdc_files(cursor_dir):
    """Collect .mdc paths from .cursor/rules/ (standard) and .cursor/ (edge case)."""
    found = {}
    rules_dir = cursor_dir / "rules"
    if rules_dir.is_dir():
        for p in sorted(rules_dir.glob("*.mdc")):
            found[p.stem] = p
    # Edge case: .mdc files directly in .cursor/ (no rules/ subdir)
    for p in sorted(cursor_dir.glob("*.mdc")):
        if p.stem not in found:
            found[p.stem] = p
    return found


# ── Output writers ────────────────────────────────────────────────────────────

def write_rule(dest_dir, name, body):
    out = dest_dir / f"{name}.md"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(body)
    return out


def write_scoped_rule(dest_dir, name, globs, body):
    out = dest_dir / f"{name}.md"
    out.parent.mkdir(parents=True, exist_ok=True)
    paths_lines = "\n".join(f"  - {g.strip()}" for g in globs.split(",")) if globs else "  - \"*\""
    content = f"---\npaths:\n{paths_lines}\n---\n\n{body}"
    out.write_text(content)
    return out


def write_skill(dest_dir, name, description, body):
    skill_dir = dest_dir / name
    skill_dir.mkdir(parents=True, exist_ok=True)
    out = skill_dir / "SKILL.md"
    desc = description or f"Skill converted from Cursor: {name}"
    content = f"---\nname: {name}\ndescription: {desc}\n---\n\n{body}"
    out.write_text(content)
    return out


def make_symlink(src_abs, dest_abs):
    """Create symlink dest → src (relative path). Overwrites if already exists."""
    dest_abs.parent.mkdir(parents=True, exist_ok=True)
    if dest_abs.exists() or dest_abs.is_symlink():
        dest_abs.unlink()
    rel = os.path.relpath(src_abs, dest_abs.parent)
    os.symlink(rel, dest_abs)


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    project_root = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path.cwd()
    cursor_dir = project_root / ".cursor"
    claude_dir = project_root / ".claude"

    if not cursor_dir.exists():
        print(f"ERROR: No .cursor/ directory found in {project_root}")
        sys.exit(1)

    rules_dir_claude = claude_dir / "rules"
    skills_dir_claude = claude_dir / "skills"
    agents_dir_claude = claude_dir / "agents"

    sync_entries = []
    rules_created = []
    scoped_rules_created = []
    skills_created = []
    agents_linked = []
    skill_dirs_linked = []

    # ── Step 1: Read .cursor/rules (plain routing file) ───────────────────────
    cursor_rules_file = cursor_dir / "rules"
    rules_file_content = ""
    if cursor_rules_file.is_file():
        rules_file_content = cursor_rules_file.read_text()

    # ── Step 2: Convert .mdc files ────────────────────────────────────────────
    mdc_files = find_mdc_files(cursor_dir)
    for stem, src_path in mdc_files.items():
        text = src_path.read_text()
        meta, body = parse_frontmatter(text)
        kind = classify_mdc(meta)
        name = stem
        description = meta.get("description", "")

        if kind == "rule":
            out = write_rule(rules_dir_claude, name, body)
            rules_created.append((name, out))
            sync_entries.append({
                "source": str(src_path.relative_to(project_root)),
                "destination": str(out.relative_to(project_root)),
                "type": "rule",
            })

        elif kind == "scoped-rule":
            globs = meta.get("globs")
            out = write_scoped_rule(rules_dir_claude, name, globs, body)
            scoped_rules_created.append((name, out))
            sync_entries.append({
                "source": str(src_path.relative_to(project_root)),
                "destination": str(out.relative_to(project_root)),
                "type": "scoped-rule",
            })

        else:  # skill
            out = write_skill(skills_dir_claude, name, description, body)
            skills_created.append((name, out))
            sync_entries.append({
                "source": str(src_path.relative_to(project_root)),
                "destination": str(out.relative_to(project_root)),
                "type": "skill",
            })

    # ── Step 3: Symlink .cursor/agents/ entries ───────────────────────────────
    cursor_agents_dir = cursor_dir / "agents"
    if cursor_agents_dir.exists():
        agents_dir_claude.mkdir(parents=True, exist_ok=True)
        for entry in sorted(cursor_agents_dir.iterdir()):
            dest = agents_dir_claude / entry.name
            make_symlink(entry, dest)
            agents_linked.append(entry.name)

    # ── Step 4: Symlink .cursor/skills/ directories ───────────────────────────
    cursor_skills_dir = cursor_dir / "skills"
    if cursor_skills_dir.exists():
        skills_dir_claude.mkdir(parents=True, exist_ok=True)
        for entry in sorted(cursor_skills_dir.iterdir()):
            if entry.is_dir():
                dest = skills_dir_claude / entry.name
                make_symlink(entry, dest)
                skill_dirs_linked.append(entry.name)

    # ── Step 5: Write sync map ────────────────────────────────────────────────
    sync_map = {
        "generated": datetime.now(timezone.utc).isoformat(),
        "entries": sync_entries,
    }
    sync_map_path = claude_dir / "cursor-sync-map.json"
    claude_dir.mkdir(parents=True, exist_ok=True)
    sync_map_path.write_text(json.dumps(sync_map, indent=2))

    # ── Step 6: Generate CLAUDE.md ────────────────────────────────────────────
    claude_md_path = project_root / "CLAUDE.md"
    if claude_md_path.exists():
        claude_md_path = claude_dir / "CLAUDE.md"

    # Read descriptions from cursor skill SKILL.md files
    cursor_skill_descriptions = {}
    if cursor_skills_dir.exists():
        for entry in sorted(cursor_skills_dir.iterdir()):
            if entry.is_dir():
                skill_md = entry / "SKILL.md"
                if skill_md.exists():
                    try:
                        meta, _ = parse_frontmatter(skill_md.read_text())
                        cursor_skill_descriptions[entry.name] = meta.get("description", "")
                    except Exception:
                        cursor_skill_descriptions[entry.name] = ""

    lines = ["# Project AI Configuration", ""]

    if rules_file_content:
        lines += ["## Routing", "", rules_file_content.strip(), ""]

    if rules_created or scoped_rules_created:
        lines += ["## Rules", ""]
        for name, _ in rules_created:
            lines.append(f"- **{name}** — always-active rule")
        for name, _ in scoped_rules_created:
            lines.append(f"- **{name}** — scoped rule")
        lines.append("")

    if agents_linked:
        lines += ["## Agents", ""]
        for name in agents_linked:
            lines.append(f"- **{name}**")
        lines.append("")

    if skills_created or skill_dirs_linked:
        lines += ["## Skills", ""]
        for name, skill_out in skills_created:
            try:
                meta, _ = parse_frontmatter(skill_out.read_text())
                desc = meta.get("description", "")
            except Exception:
                desc = ""
            lines.append(f"- **/{name}** — {desc}" if desc else f"- **/{name}**")
        for name in skill_dirs_linked:
            desc = cursor_skill_descriptions.get(name, "")
            lines.append(f"- **/{name}** — {desc}" if desc else f"- **/{name}**")
        lines.append("")

    claude_md_path.write_text("\n".join(lines))

    # ── Report ────────────────────────────────────────────────────────────────
    print("/init-from-cursor complete")
    print("─" * 50)
    print(f"Rules created:         {len(rules_created)}")
    for name, p in rules_created:
        print(f"  {p.relative_to(project_root)}")
    print(f"Scoped rules created:  {len(scoped_rules_created)}")
    for name, p in scoped_rules_created:
        print(f"  {p.relative_to(project_root)}")
    print(f"Skills created:        {len(skills_created)}")
    for name, p in skills_created:
        print(f"  {p.relative_to(project_root)}")
    print(f"Agents symlinked:      {len(agents_linked)}")
    for name in agents_linked:
        print(f"  .claude/agents/{name}")
    print(f"Skill dirs symlinked:  {len(skill_dirs_linked)}")
    for name in skill_dirs_linked:
        print(f"  .claude/skills/{name}")
    print(f"Sync map:              .claude/cursor-sync-map.json")
    print(f"CLAUDE.md:             {claude_md_path.relative_to(project_root)}")
    print("─" * 50)
    print("To re-sync after Cursor changes: /update-from-cursor")


if __name__ == "__main__":
    main()

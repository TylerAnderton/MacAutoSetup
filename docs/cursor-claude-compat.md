# Cursor and Claude Code compatibility

What is known about how each tool loads skills and rules. Each finding is tagged **documented** (vendor docs), **tested** (checked on this machine), or **reported** (forum or user report, not independently verified). Last verified: 2026-10-12.

## Skills

| Finding | Status |
|---|---|
| Cursor loads skills from `~/.agents/skills`, `~/.cursor/skills`, and, for compatibility, `~/.claude/skills` and `~/.codex/skills`, plus the project-level equivalents | documented |
| Cursor reads `~/.claude/skills` and `~/.agents/skills`. Method: with `plan-with-review` linked in both places, deleting both links made Cursor lose the skill after a restart. Restoring only the `~/.claude/skills` link brought it back. A separate test with only `~/.agents/skills` also worked | tested, October 2026 |
| A skill reachable through several roots is listed several times, which bloats context. This is why each custom skill is placed in exactly one root, `~/.claude/skills` | reported |
| Cursor shows the symlink-resolved path for a skill, so "reveal in Finder" cannot tell which root it was found through | tested |
| The IDE has a compatibility toggle (Settings, Rules, Skills and Subagents) for the Claude and Codex roots. The toggle does not apply to the CLI | reported |
| The CLI slash menu once listed only `.cursor/skills` while auto-invocation did read `~/.agents/skills`. A fix was promised. Symlinks under `~/.cursor/skills` were reported to fail once | reported, CLI version 2026.03.18, not re-checked |
| Claude Code reads `~/.claude/skills` and not `~/.agents/skills`. The `skills` CLI installs into `~/.agents/skills` and links into `~/.claude/skills` for this reason | observed from the existing link layout |

## Rules and instructions

| Finding | Status |
|---|---|
| Cursor User Rules exist only in the Settings UI. A user-level `AGENTS.md` is not documented. `~/.cursor/rules/*.mdc` is the only file-based global channel | documented |
| `.mdc` rules with `alwaysApply: true` are sometimes treated as requestable instead of always injected, and `AGENTS.md` is not always injected | reported |
| Cursor cannot import files from a rule, so the core workflow text is generated into `workflow.mdc` rather than referenced | documented format limit |
| Claude Code supports `@path` imports in `CLAUDE.md`, resolved relative to the importing file | documented |
| Permission rule paths accept a `~/` prefix for the home directory. `permissions.additionalDirectories` is documented without saying whether `~` is expanded | documented for rules, unverified for additionalDirectories |

## Behavior the workflow depends on

| Finding | Status |
|---|---|
| Cursor Plan mode blocks the CLI commands Plannotator needs, so Cursor must not enter it | reported by the repo owner |
| The Cursor agent cannot create `/tmp` marker files from its sandbox, which is why the commit gate was removed | reported by the repo owner |
| A skill or hook cannot run `/compact` or `/summarize`, and an agent cannot switch its own model | design constraint |

## Checks still to run after merging to the main checkout

Record results here when done.

- [ ] `tests/check-workflow-config.sh --installed` passes from the main checkout.
- [ ] Cursor lists `plan-with-review`, `tdd-with-review`, and `jira-tickets` once each.
- [ ] Cursor injects `workflow.mdc`: in a fresh chat, ask it to state the workflow's mandatory questions without opening any file. If it does not, add a short pointer to the workflow in Cursor's User Rules settings as a backstop.
- [ ] Claude Code resolves the `@WORKFLOW.md` import (start a session and ask for the mandatory intake questions).
- [ ] Claude Code opens the worktree path and Obsidian vault without prompts, confirming `~` works in `additionalDirectories`.
- [ ] The Claude ruff hook formats and fixes a scratch Python file.

## Sources

- [Cursor: Agent Skills](https://cursor.com/docs/skills)
- [Cursor: Rules](https://cursor.com/docs/rules)
- [Cursor forum: toggle for skills roots](https://forum.cursor.com/t/toggle-or-allowlist-for-agent-skills-roots-stop-loading-claude-skills-and-codex-skills-when-i-only-want-cursor-agents/160199)
- [Cursor forum: skills in ~/.agents/skills not loaded by the CLI](https://forum.cursor.com/t/skills-in-agents-skills-are-not-loaded-by-the-cli/155358)
- [Cursor forum: alwaysApply rules treated as requestable](https://forum.cursor.com/t/alwaysapply-true-rules-and-cursorrules-both-silently-treated-as-requestable-instead-of-auto-injected-cursor-3-0-16-macos/157431)
- [Claude Code: permissions](https://code.claude.com/docs/en/permissions)
- [Claude Code: settings](https://code.claude.com/docs/en/settings)

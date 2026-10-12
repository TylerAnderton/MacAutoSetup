# Docs

Documentation for the Claude Code and Cursor workflow in this repo. The config itself lives under `dotfiles/claude/User/.claude/` (Claude Code and Cursor skills, core workflow, settings) and `dotfiles/Cursor/.cursor/rules/` (generated Cursor rule).

| Doc | Owns |
|---|---|
| [workflow.md](workflow.md) | What the workflow does end to end, how to use it, and what each platform does differently |
| [skills.md](skills.md) | Each skill, where its files live, how both platforms find them, and which skills are managed by plugins |
| [cursor-claude-compat.md](cursor-claude-compat.md) | Researched and tested facts about how Cursor and Claude Code load skills and rules, with sources |
| [design-decisions.md](design-decisions.md) | Why the workflow is built this way |

## Conventions

- Each doc owns one topic. Link instead of repeating.
- Every claim about Cursor or Claude Code behavior is tagged documented, tested, or reported, with a "last verified" date, in `cursor-claude-compat.md`.
- Paths use `~`, `$HOME`, or repo-relative form, never a specific user's home directory, because the repo is shared across machines.
- Update the docs in the same commit as any change to the workflow, skills, or settings they describe.
- Check the config with `tests/check-workflow-config.sh`. Add `--installed` from the main checkout to check the live links under `$HOME`.

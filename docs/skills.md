# Skills

## Custom skills

All three are real directories under `dotfiles/claude/User/.claude/skills/`. Claude Code and Cursor both read `~/.claude/skills`, and `~/.claude` is a directory link to `dotfiles/claude/User/.claude` created by `bootstrap.sh`. A `git pull` is the whole update process.

| Skill | Use it for | Files |
|---|---|---|
| `plan-with-review` | Intake questions, branch and worktree setup, spec-only plan, Obsidian copy, the pause for compact and model switch | `SKILL.md`, `references/worktree.md` |
| `tdd-with-review` | RED tests, review, implementation, pytest, pyright, docs and their review, final review, commit | `SKILL.md`, `references/tdd-discipline.md`, `references/writing-good-tests.md`, `references/LICENSE-superpowers.md` |
| `jira-tickets` | Interviewing, drafting, reviewing, and writing Jira tickets | `SKILL.md` |

The two TDD references are adapted from the `test-driven-development` skill of the superpowers plugin (MIT; the license notice is kept in `references/LICENSE-superpowers.md`). They are copies modified for this workflow, so the custom skills do not depend on the plugin, and it can be uninstalled.

The phase order and hard rules are in `dotfiles/claude/User/.claude/WORKFLOW.md`, not in the skills, because deterministic rules must live in base config (see [design-decisions.md](design-decisions.md)). The skills hold how, not what order.

## Do not edit: managed by plugins or the skills CLI

These are overwritten on update, so changes are lost. Reference them by name only.

- Synced by the Plannotator plugin into `~/.claude/skills`: `plannotator`, `plannotator-annotate`, `plannotator-last`, `plannotator-review`, and the `synced/` directory.
- Installed by the `skills` CLI (recorded in `~/.agents/.skill-lock.json`): `find-skills`, `plannotator-compound`, `plannotator-setup-goal`, `plannotator-visual-explainer`.
- Plugin-provided skills from marketplaces (superpowers, skill-creator, and others).

`~/.agents/skills` is for `skills` CLI installs. Do not place or link the custom skills there, or Cursor lists them twice. If an older machine still has hand-made links, remove them once:

```bash
rm ~/.agents/skills/plan-with-review ~/.agents/skills/tdd-with-review
```

## Adding or changing a skill

1. Create or edit `dotfiles/claude/User/.claude/skills/<name>/SKILL.md`. The folder name must match the `name` field, the description should say what the skill does and when to use it, and detail that is not always needed belongs in `references/`.
2. If the change affects the pipeline, edit `WORKFLOW.md` instead, then run `scripts/sync-cursor-rule.sh --write`.
3. Run `tests/check-workflow-config.sh`.
4. Update these docs in the same commit.

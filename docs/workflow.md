# Workflow

A one-line task prompt should be enough. Everything that used to be pasted into every prompt (branch naming, worktree location, plan format, Obsidian destination, review commands, model-switch pause) is encoded in the config below. See [skills.md](skills.md) for the files and [design-decisions.md](design-decisions.md) for the reasoning.

## Where the rules live

- `dotfiles/claude/User/.claude/WORKFLOW.md` is the single source for the non-skippable pipeline. Claude Code reads it through an `@WORKFLOW.md` import in `CLAUDE.md`. Cursor reads a generated copy, `dotfiles/Cursor/.cursor/rules/workflow.mdc`. After editing `WORKFLOW.md`, run `scripts/sync-cursor-rule.sh --write` and commit the result; the validator fails if they drift.
- The skills `plan-with-review`, `tdd-with-review`, and `jira-tickets` hold the detail.

## The pipeline

Plan, review, pause, RED, review, GREEN, review, commit. It is one linear flow, not a list of separate tasks.

| Phase | What happens |
|---|---|
| Intake | The agent asks every clarifying question, plus these mandatory ones: use a worktree? What is the full path of the Obsidian folder, and the plan name (unless you gave them)? Delegate to subagents? (default inline) |
| Branch and worktree | If you chose a worktree: branch `{feature\|fix}/<TICKET>-<CamelCaseBrief>` (or `{feature\|fix}/<kebab-brief>` without a ticket), worktree beside the main checkout as `<main-checkout-dir>-<identifier>` |
| Plan | A spec with no code: behavior, files, interfaces in prose, tests, acceptance criteria, doc updates |
| Plan review | Claude Code: plan mode with Plannotator approval. Cursor: the plan file is reviewed with `plannotator annotate --gate --json` and Cursor never enters Plan mode |
| Pause | The plan is copied to Obsidian, then the agent stops and asks you to compact and switch models |
| RED | Failing tests, reviewed with `--diff-type unstaged`, then staged |
| Implement | Minimal code, then the project's whole test suite to GREEN, then `pyright` on the changed files |
| Docs | If the project has `docs/` and the change is non-trivial, docs are updated in the same change, then opened in Plannotator annotate for review before the code review |
| Code review | `--diff-type unstaged`; reviewed work is staged between rounds |
| Commit | Automatic after final approval, Conventional Commits, no push |

Python steps (pytest, pyright) run only when the project has a `pyproject.toml`. Formatting and linting, such as ruff, are project-level rules that live in each project, because those tools are not installed everywhere.

## The pause: compact and switch models

After plan approval the agent stops on purpose. Planning is worth a high-power model; implementation can run on a cheaper one. Neither a skill nor a hook can run `/compact`, `/summarize`, or switch models, so you do it:

1. Run `/compact` in Claude Code or `/summarize` in Cursor.
2. Switch to the implementation model.
3. Tell the agent to continue. The approved plan is also saved in the Obsidian folder you chose.

## Reviews

- Claude Code: `/plannotator-review --diff-type unstaged`
- Cursor: `plannotator review --diff-type unstaged`

New files only appear in an unstaged diff after `git add -N <file>`. For a worktree outside the session directory, the worktree path is passed as the review target. A review that times out or is stopped in the background is not an approval.

## Jira tickets

Ask for the `jira-tickets` skill (for example "fill in the description for CI-1234"). It interviews you first, learns conventions from parent and sibling tickets, reviews each draft in Plannotator, saves a copy to the Obsidian `Tickets/` folder whose full path you give it, and then updates or creates the ticket through the Atlassian MCP. Plannotator approval is the gate for the Jira write.

## Not part of the workflow

There is no commit gate and no flag file. Nothing here pushes or opens a pull request.

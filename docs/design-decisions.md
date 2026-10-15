# Design decisions

The reasoning behind the workflow. What it does is in [workflow.md](workflow.md); the facts about each tool are in [cursor-claude-compat.md](cursor-claude-compat.md).

## No commit gate

The old gate blocked `git commit` until a `/tmp` flag file existed. Cursor's sandbox cannot create that file, so every Cursor session needed an instruction to ignore the gate. It cost more than it protected. The review step remains a procedure in `WORKFLOW.md`; it is simply not enforced by a hook.

## Deterministic rules live in base config, not skills

A skill is loaded when the model judges it relevant, so it can be skipped. Anything that must never be skipped (the phase order, the mandatory questions, the pause, the Cursor ban on Plan mode) is in `WORKFLOW.md`, which Claude Code imports from `CLAUDE.md`. Skills hold how-to detail only. The consequence is that the pipeline cannot be fully atomized into skills.

## One source for the core, a generated Cursor rule

Cursor cannot import files, and a user-level `AGENTS.md` is not documented for it. The only file-based global channel is `~/.cursor/rules/*.mdc`. Instead of maintaining two copies by hand, `scripts/sync-cursor-rule.sh` generates `workflow.mdc` from `WORKFLOW.md`, and the validator fails if they differ. The script runs when authoring; other machines get the committed output with `git pull`. The core file is not named `AGENTS.md` because nothing here assumes Cursor reads that name from `~/.claude/`.

## Skills live only in `~/.claude/skills`

Cursor reads `~/.claude/skills` (tested), and Claude Code reads only that root. Keeping the real files there removes the former `dotfiles/agents/` directory and its symlinks. A second copy or link under `~/.agents/skills` would make Cursor list each skill twice. `~/.agents/skills` is left for skills installed by the `skills` CLI.

## `git pull` is the update mechanism

`bootstrap.sh` runs once on a new machine. Nothing in the workflow requires re-running it or any script to update an existing machine. This is why skills are real files in a directory already linked to the repo, and why paths in settings use `~/` forms so one file serves every machine.

## Cursor never enters Plan mode

Plan mode blocks the CLI commands Plannotator needs. Cursor writes a plan file and reviews it with `plannotator annotate --gate --json`. Claude Code's plan mode works with Plannotator natively, so it keeps using it.

## Manual compact and model switch

Planning benefits from a high-power model and implementation does not. A skill or hook cannot run `/compact` or `/summarize` or switch models, so the workflow stops after plan approval, says why, and asks the user to do it. `/compact` is preferred over `/clear`, which loses more context. The approved plan is also saved in Obsidian.

## Unstaged review with staging between rounds

Code review always uses `plannotator review --diff-type unstaged`. After each approved review the work is staged, and review fixes stay unstaged, so every round shows only what is new. Tests are reviewed the same way instead of with `plannotator annotate`, which treats them as a document rather than a diff. Nothing is committed until the final review is approved, because committing early would hide changes from review. Staged means already reviewed, so agents never unstage a path that is already in the index (no `git reset`, `git restore --staged`, or `git add -N` on it) to fit it into a review; `git add -N` is only for untracked paths.

## Plans are one linear flow with no code

A multi-task plan invites the implementer to treat each task as its own mini-project. The plan is a single pass (plan, review, RED, review, GREEN, review) and is split into tasks only for explicit subagent delegation. It contains no code because the plan's job is to fix requirements, and code in a plan gets copied without being checked against the tests.

## Sibling worktrees

A worktree sits next to the main checkout as `<main-checkout-dir>-<identifier>` instead of under `worktrees/`, so both are one directory level apart and easy to open side by side. The identifier is the Jira ID when there is one, otherwise the kebab brief. Whether to use a worktree is always asked, because it is not needed for every task.

## Pyright, docs, and what is left to the project

Pyright runs only after tests are GREEN because type errors in code that does not yet behave correctly are noise. Docs are updated in the same change as non-trivial code and reviewed as documents in Plannotator annotate, so `docs/` never lags the code. They are written after the GREEN code review is approved so they describe the code as it was finally reviewed, not a version that review feedback may still change.

Formatting and linting (ruff) are deliberately not in the user-level workflow. Ruff is not installed in every environment, so it is a project-level rule that each project configures. The user-level Claude hook that runs ruff after a Python edit only runs when ruff is on the path, and does nothing otherwise.

## TDD references are copies, not a plugin dependency

The superpowers plugin may be uninstalled, so the TDD discipline and test-quality rules were copied into `tdd-with-review/references/` and modified for this workflow (Python examples, the review gate, no cross-plugin references). The original is MIT-licensed, so its notice is kept next to the copies.

## Dropped tools

Caveman (token-saving mode), Graphite, and uv were removed because they are no longer used, and keeping their permissions, hooks, and package entries only added noise. Ruff and pyright are invoked directly.

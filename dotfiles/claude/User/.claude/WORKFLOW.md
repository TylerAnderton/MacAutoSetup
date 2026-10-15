# Workflow (core)

Applies to Claude Code and Cursor. This file owns the order of phases and the non-negotiable rules. Craft detail lives in the skills it names. Skip this workflow for trivial one-off fixes (typo, single-line change, config tweak). For everything else, follow it exactly.

## Platform rules

- **Claude Code:** use native plan mode for planning (Plannotator intercepts plan-mode exit). Review code with `/plannotator-review --diff-type unstaged`.
- **Cursor:** never enter Plan mode, because it blocks the CLI commands Plannotator needs. Write the plan as a markdown file under `~/.cursor/plans/` and review it with `plannotator annotate --gate --json <plan-file>`. Review code with `plannotator review --diff-type unstaged`.
- Code review always uses `--diff-type unstaged`, never `plannotator annotate`. When working in a worktree outside the session directory, pass the worktree path as the review target.
- Plans and docs are reviewed as documents: in Claude Code with the `plannotator-annotate` skill, in Cursor with `plannotator annotate --gate --json <files>`.
- The review commands block until the user decides. Never treat a timeout, a background-task notice, or silence as approval.

## Phases

1. **Intake.** Use the `plan-with-review` skill. For every non-trivial task, ask all of these before planning, even when the answer seems obvious:
   - every requirement that is unclear;
   - whether to use a worktree;
   - the full path of the Obsidian folder and the plan file name, unless the prompt already gave them;
   - whether to delegate to subagents (default is inline).
2. **Branch and worktree**, if the user chose one. Follow `references/worktree.md` in `plan-with-review`.
3. **Plan.** Spec only: behavior, files by path, names and interfaces in prose, test cases, acceptance criteria, and expected `docs/` updates. No code blocks. One linear flow (plan, review, RED, review, GREEN, review, commit) with no multi-task breakdown unless the tasks are explicitly for subagent delegation. Detailed enough for a weaker model to implement without the planning conversation.
4. **Plan review, then pause.** After approval, copy the plan to the Obsidian destination and stop. Do not start implementation in the same turn. Tell the user why: planning runs on a high-power model and implementation should run on a cheaper one. Ask them to run `/compact` (Claude Code) or `/summarize` (Cursor), switch models, then say to continue. Neither command nor the model switch can be done automatically.
5. **Implement.** Use the `tdd-with-review` skill: RED tests, review, minimal implementation, pytest to GREEN, pyright, code review.
6. **Docs.** After the GREEN code review is approved: if the project has a `docs/` directory and the change is non-trivial (behavior, public API, config, architecture), update those docs per that project's conventions in the same change. Typos, internal refactors, and test-only changes are not non-trivial. Open the changed docs in Plannotator annotate for review and address the feedback before committing.
7. **Commit.** After the final review is approved, commit automatically using Conventional Commits. Never push and never open a pull request unless asked.

## Review loop

After each approved review, `git add` the reviewed work. Fixes for review feedback stay unstaged, so the next `--diff-type unstaged` review shows only new changes. Repeat until a review returns no feedback.

Staged work has already been reviewed. If the diff you need to review is already staged, there is nothing new to review; never unstage it to fit it into a review.

## Hard rules

- Never unstage, `git reset`, `git restore --staged`, or `git add -N` a path that is already in the index, unless the user asks. Use `git add -N` only for untracked paths that are not in the index yet.
- Never edit tests to force a pass.
- Python steps (pytest, pyright) run only when the project has a `pyproject.toml`.
- Never modify skills installed or synced by plugins or the `skills` CLI; they are overwritten on update.

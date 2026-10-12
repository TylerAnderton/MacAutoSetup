---
name: tdd-with-review
description: Use when implementing an approved plan, feature, or bugfix. Writes failing tests first and gets them reviewed in Plannotator before any implementation exists, then implements to green with pytest and pyright, updates and reviews docs, and gets the final code review before an automatic commit.
allowed-tools: Bash(plannotator:*)
---

# TDD With Review

The phase order and hard rules live in `WORKFLOW.md`. This skill is the detail for phases 5 to 7. Python steps (pytest, pyright) apply only when the project has a `pyproject.toml`; otherwise use the project's own test runner and skip them. Formatting and linting (for example ruff) are project-level rules: follow the project's own configuration if it has one.

## Steps

1. **RED.** Write failing tests following `references/tdd-discipline.md` and `references/writing-good-tests.md`. Run them and confirm they fail for the right reason (feature missing, not a typo).

2. **Review the tests before writing any implementation.** Run the unstaged code review (commands below). Iterate until approved, then `git add` the reviewed tests.

3. **Implement** the minimal code to pass, per the delegation preference collected during planning (default inline).

4. **GREEN.** Run the project's whole test suite. If anything fails, fix the implementation, never the tests.

5. **Type check.** Only after GREEN, run `pyright` on the changed files. Fix errors your change introduced. Report pre-existing errors without fixing them.

6. **Docs.** If the project has a `docs/` directory and the change is non-trivial, update the docs per that project's conventions. Then open the changed docs in Plannotator annotate (commands below) and address the feedback before the code review.

7. **Code review.** Run the unstaged code review. Fix any feedback, leaving the fixes unstaged, and re-review until it returns clean. `git add` the approved work after each approved round.

8. **Commit** automatically once the final review is clean: Conventional Commits message, with the attribution trailer the environment specifies. Do not push.

## Review commands

Code and tests are always reviewed as unstaged changes, never with the annotate command.

- **Claude Code:** `/plannotator-review --diff-type unstaged`. The skill passes its arguments straight to `plannotator review`.
- **Cursor:** `plannotator review --diff-type unstaged`

When the work is in a worktree outside the session directory, pass the worktree path as the target. New files do not appear in an unstaged diff until marked with `git add -N <file>`.

Docs are reviewed as documents, not diffs:

- **Claude Code:** the `plannotator-annotate` skill on the changed doc files.
- **Cursor:** `plannotator annotate --gate --json <doc-files>`

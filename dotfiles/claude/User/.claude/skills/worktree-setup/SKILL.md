---
name: worktree-setup
description: "Set up a git worktree for isolated development. Use when a subagent needs an isolated workspace. Always use Pattern A: gt create first on the main checkout, then git worktree add to attach. NEVER base worktrees on master/main."
---

# Worktree Setup

## Pattern A — always use this

```bash
# Step 1: On the main checkout, ensure you're on the current feature branch
gt checkout metrics-anomalies/mlmp-491   # the numbered ticket branch, NOT master

# Step 2: Create and register the branch with gt
gt create metrics-anomalies/mlmp-491-subtask -am "feat: initial"

# Step 3: Attach a worktree to the already-tracked branch
git worktree add .worktrees/mlmp-491-subtask metrics-anomalies/mlmp-491-subtask
```

**Why:** `gt create` registers branch in Graphite's stack. `git worktree add` (no `-b`) attaches to registered branch. Using `git worktree add -b` creates branch but skips registration — breaks stack tracking.

## Critical Rules

| Rule | Detail |
|------|--------|
| Base branch | Current numbered feature branch (e.g. `metrics-anomalies/mlmp-491`) |
| Never base on | `master`, `main`, non-feature branches |
| Branch creation | `gt create` on main checkout first — never inside worktree |
| No `-b` flag | `git worktree add .worktrees/name <branch>` only |

## Provide Branch to Subagent

After setup, tell subagent:

```
Working directory: /path/to/repo/.worktrees/mlmp-491-subtask
Branch: metrics-anomalies/mlmp-491-subtask
Parent branch: metrics-anomalies/mlmp-491
Main checkout: /path/to/repo
```

Subagent commits with `gt modify` from inside worktree. Branch already registered — no `gt track` needed.

## Python Testing

Don't run `uv run pytest` inside worktree. Use `testing-worktree-uv` skill to run tests from main checkout against temp branch.

## Cleanup

```bash
git worktree remove .worktrees/<name>
# Optionally delete the branch after merging:
# gt branch delete metrics-anomalies/mlmp-491-subtask
```

## Verify Worktree List

```bash
git worktree list
```
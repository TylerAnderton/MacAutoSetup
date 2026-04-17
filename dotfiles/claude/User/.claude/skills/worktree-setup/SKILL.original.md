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

**Why this order matters:** `gt create` registers the branch in Graphite's stack. `git worktree add` (without `-b`) attaches to an already-registered branch. If you use `git worktree add -b`, the branch is created but not registered — breaking stack tracking.

## Critical Rules

| Rule | Detail |
|------|--------|
| Base branch | Always the current numbered feature branch (e.g. `metrics-anomalies/mlmp-491`) |
| Never base on | `master`, `main`, or any non-feature branch |
| Branch creation | `gt create` on main checkout first — never inside the worktree |
| No `-b` flag | `git worktree add .worktrees/name <branch>` only — no `git worktree add -b` |

## Providing Branch to Subagent

After setup, tell the subagent:

```
Working directory: /path/to/repo/.worktrees/mlmp-491-subtask
Branch: metrics-anomalies/mlmp-491-subtask
Parent branch: metrics-anomalies/mlmp-491
Main checkout: /path/to/repo
```

The subagent commits with `gt modify` from inside the worktree. Branch is already registered — no `gt track` needed.

## Python Testing

Do NOT run `bazel test` inside the worktree. Use the `testing-worktree-uv` skill to run tests from the main checkout against a temp branch.

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

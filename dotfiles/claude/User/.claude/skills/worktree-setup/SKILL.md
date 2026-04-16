---
name: worktree-setup
description: "Set up a git worktree for isolated development. Use when a subagent needs an isolated workspace. Always use Pattern A: gt create first from the repo root, then git worktree add to attach. NEVER base worktrees on master/main or temp-test branches."
---

# Worktree Setup

## Critical Context

**The orchestrator session is NOT on the feature branch.** The current checkout in the orchestrator's working directory is typically a `temp-test-*` branch — a throwaway branch, not a development branch. Do NOT base any work on it.

All branch creation must happen explicitly on the correct feature branch, regardless of what is currently checked out.

## Pattern A — always use this

```bash
# Step 1: From the repo root (e.g. /Users/tyleranderton/Repositories/tractian-ai),
#          explicitly switch to the feature branch — do NOT assume current branch is correct
gt checkout metrics-anomalies/mlmp-491   # the numbered ticket branch, NOT master, NOT temp-test-*

# Step 2: Create and register the sub-branch with gt (stacks on the feature branch above)
gt create metrics-anomalies/mlmp-491-subtask -am "feat: initial"

# Step 3: Attach a worktree to the already-tracked branch (no -b flag)
git worktree add .worktrees/mlmp-491-subtask metrics-anomalies/mlmp-491-subtask
```

**Why:** `gt create` registers branch in Graphite's stack. `git worktree add` (no `-b`) attaches to registered branch. Using `git worktree add -b` creates branch but skips registration — breaks stack tracking.

## Critical Rules

| Rule | Detail |
|------|--------|
| Base branch | Explicitly checked-out feature branch (e.g. `metrics-anomalies/mlmp-491`) |
| Never base on | `master`, `main`, `temp-test-*`, or whatever is currently checked out by default |
| Branch creation | `gt checkout <feature-branch>` first, then `gt create` — from repo root, never inside worktree |
| No `-b` flag | `git worktree add .worktrees/name <branch>` only |
| Verify before create | Run `git branch --show-current` to confirm you are on the correct base branch |

## Provide Branch to Subagent

After setup, tell subagent:

```
Repo root: /Users/tyleranderton/Repositories/tractian-ai
Working directory: /Users/tyleranderton/Repositories/tractian-ai/.worktrees/mlmp-491-subtask
Branch: metrics-anomalies/mlmp-491-subtask
Parent branch: metrics-anomalies/mlmp-491
```

Do NOT use the term "main checkout" — it is ambiguous. Always refer to the repo root by its absolute path.

Subagent commits with `gt modify` from inside worktree. Branch already registered — no `gt track` needed.

## Enforce in Dispatch

The orchestrator MUST copy the following block verbatim into the prompt of every subagent it dispatches. Fill in the bracketed values before sending:

```
Repo root: /Users/tyleranderton/Repositories/tractian-ai
Working directory: /Users/tyleranderton/Repositories/tractian-ai/.worktrees/<name>
Branch: <branch-name>
Parent branch: <parent-feature-branch>

BRANCH RULES:
- Do NOT create new branches. Your branch is already set up.
- Commit with `gt modify` (never `git commit`)
- Do NOT run `uv run pytest` inside the worktree — report tests needed; orchestrator dispatches tester
- All edits go in Working directory above. Never edit files in the repo root.
```

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
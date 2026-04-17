---
name: testing-worktree-uv
description: "Test Python changes made in git worktrees using bazel test. Use when bazel test needs to run against worktree changes — uv editable installs resolve to main checkout, so tests must run from main tree on a temp branch. Invoke whenever testing Python code developed in a worktree."
---

# testing-worktree-uv

## Overview

`uv` editable installs symlink the project to `.venv`. A worktree checks out a different branch, but the symlink still points to the main checkout's source. Running `bazel test` inside a worktree tests stale code.

**Fix:** Run bazel test from the main checkout on a temp branch that mirrors the worktree's changes.

---

## Procedure

### Step 1 — Determine location

```bash
git rev-parse --show-toplevel
git worktree list
```

If toplevel matches the main repo → on main tree. If matches a worktree path → in worktree.

### Step 2 — If on main tree with valid feature branch

Skip to Step 5. Run `bazel test` directly.

```bash
git branch --show-current
```

### Step 3 — If in a worktree — check for temp-test branch

Determine the ticket number from the worktree branch (e.g. `metrics-anomalies/mlmp-491-subtask` → ticket `491`).

```bash
git -C <main-tree-path> branch --list 'temp-test-491*'
```

### Step 4 — Create or update temp-test branch on main tree

Temp-test branches are **disposable, untracked testing artifacts** — do NOT register with `gt track`.

**If temp-test branch doesn't exist:**
```bash
git -C <main-tree-path> checkout -b temp-test-491 <worktree-branch>
```

**If it exists:**
```bash
git -C <main-tree-path> checkout temp-test-491
git -C <main-tree-path> merge <worktree-branch>
```

Temp-test branches follow `temp-test-<TICKET>` naming (e.g. `temp-test-491`). They are never submitted or pushed.

### Step 5 — Run bazel test from main tree

Always run from the main checkout, never from inside the worktree directory:

```bash
cd <main-tree-path> && bazel test //mle/libs/metrics_anomalies/...
```

---

## Subagent Rule

Subagents working in worktrees must NOT run bazel test themselves. They should:
1. Commit their changes with `gt modify`
2. Report to the orchestrator that tests need to be run
3. The orchestrator runs this skill from the main checkout

---

## Background

`uv` symlinks project → `.venv` for editable installs. Worktree checks out a branch, but the symlink still points to main tree source. `bazel test` inside worktree tests stale code from the main checkout, not the worktree changes.

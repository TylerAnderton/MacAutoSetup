---
name: testing-worktree-uv
description: "`uv` editable symlink main tree. Worktree bazel test stale code. Run bazel test from main on temp branch. Use when testing Python in worktree."
---

# testing-worktree-uv

## Overview

`uv` editable symlink project to `.venv`. Worktree check different branch, symlink still point main. `bazel test` in worktree test stale code.

**Fix:** Run bazel test from main checkout on temp branch mirror worktree.

---

## Procedure

### Step 1 — Determine location

```bash
git rev-parse --show-toplevel
git worktree list
```

toplevel = main repo → on main tree. worktree path → in worktree.

### Step 2 — If on main tree with valid feature branch

Skip to Step 5.

```bash
git branch --show-current
```

### Step 3 — If in a worktree — check for temp-test branch

Extract <ticket-number> from branch name (e.g. `metrics-anomalies/mlmp-491-subtask` → `491`).

```bash
git -C <main-tree-path> branch --list 'temp-test-<ticket-number>*'
```

### Step 4 — Create or update temp-test branch on main tree

Temp-test branches disposable, untracked — do NOT register with `gt track`.

**No temp-test branch:**
```bash
git -C <main-tree-path> checkout -b temp-test-<ticket-number> <worktree-branch>
```

**Exist:**
```bash
git -C <main-tree-path> checkout temp-test-<ticket-number>
git -C <main-tree-path> merge <worktree-branch>
```

Follow `temp-test-<ticket-number>` naming. Never submit or push.

### Step 5 — Run bazel test from main tree

Run from main checkout, never worktree directory:

```bash
cd <main-tree-path> && bazel test //mle/libs/metrics_anomalies/...
```

---

## Subagent Rule

Subagents in worktree: do NOT run bazel test. Instead: 1) commit with `gt modify`, 2) report tests needed to orchestrator.

Orchestrator dispatches the `tester` agent — never runs bazel test directly. `tester` handles worktree detection automatically.

---

## Background

`uv` symlinks project → `.venv` for editable installs. Worktree checks out a branch, but the symlink still points to main tree source. `bazel test` inside worktree tests stale code from the main checkout, not the worktree changes.

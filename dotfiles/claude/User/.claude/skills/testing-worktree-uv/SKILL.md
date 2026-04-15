---
name: testing-worktree-uv
description: "`uv` editable symlink main tree. Worktree pytest test stale code. Run pytest from main on temp branch. Use when testing Python in worktree."
---

# testing-worktree-uv

## Overview

`uv` editable symlink project to `.venv`. Worktree check different branch, symlink still point main. `uv run pytest` in worktree test stale code.

**Fix:** Run pytest from main checkout on temp branch mirror worktree.

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

Extract ticket from branch name (e.g. `metrics-anomalies/mlmp-491-subtask` → `491`).

```bash
git -C <main-tree-path> branch --list 'temp-test-491*'
```

### Step 4 — Create or update temp-test branch on main tree

Temp-test branches disposable, untracked — do NOT register with `gt track`.

**No temp-test branch:**
```bash
git -C <main-tree-path> checkout -b temp-test-491 <worktree-branch>
```

**Exist:**
```bash
git -C <main-tree-path> checkout temp-test-491
git -C <main-tree-path> merge <worktree-branch>
```

Follow `temp-test-<TICKET>` naming. Never submit or push.

### Step 5 — Run pytest from main tree

Run from main checkout, never worktree directory:

```bash
cd <main-tree-path> && uv run pytest <test-paths>
```

---

## Subagent Rule

Subagents in worktree: do NOT run pytest. Instead: 1) commit with `gt modify`, 2) report tests needed to orchestrator.

Orchestrator dispatches the `tester` agent — never runs pytest directly. `tester` handles worktree detection automatically.

---

## Background

`uv` symlink point main tree. Worktree checkout separate branch, symlink unchanged. Test worktree code → test main code instead.
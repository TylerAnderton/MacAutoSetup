---
name: testing-worktree-uv
description: "Worktree code untestable by bazel (`uv` symlinks stale). Use patches to transfer changes to main temp test branch, run bazel, transfer fixes back. Use when testing Python worktree."
---

# testing-worktree-uv

## Overview

`uv` editable symlink project to `.venv`. Worktree check different branch, symlink still point main. `bazel test` in worktree test stale code.

**Fix:** Run bazel test from main checkout on temp branch mirror worktree.


## The Patch Pattern (Worktree-to-Main Sync)
Because `uv` and `bazel` require the main checkout environment, we migrate changes without using `git merge` to protect Graphite stacks.

To prevent Graphite metadata corruption and handle Bazel requirements:
1. **Never** merge temp branches into feature branches.
2. **Never** use `gt create` for transient test branches.
3. **Always** use patches to move code between the Worktree and Main Checkout.

### Sync Workflow:
1. **Export:** `git diff $(gt branch info --json | jq -r '.parent') > /tmp/sync.patch`
2. **Apply (Main):** `git apply /tmp/sync.patch` on a transient `git checkout -b temp-sync`.
3. **Execute:** Run `bazel run //:gazelle`, `bazel run //:format -- <files or targets>`, and `bazel test //<targets>`, 
4. **Capture:** `git diff > /tmp/fixed.patch`.
5. **Restore (Worktree):** `git apply /tmp/fixed.patch`.

---
## The Master Patch Protocol
Use this protocol to move work between the **Worktree** (coding) and **Main Checkout** (testing/formatting) to avoid Graphite metadata corruption.

1. **Export (Worktree):** `git diff $(gt branch info --json | jq -r '.parent') > /tmp/sync.patch`
2. **Apply changes (Main):** `git apply /tmp/sync.patch`
3. **Execute (Main):** Run `bazel run //:gazelle`, `bazel run //:format`, and `bazel test`.
4. **Capture (Main):** `git add -A && git diff HEAD > /tmp/fixed.patch`
5. **Apply (Worktree):** `git apply /tmp/fixed.patch`
## Procedure

### Step 1a — Create test branch (if doesn't exist)
From the repo root (e.g. /Users/tyleranderton/Repositories/tractian-ai), create temp-test branch based on worktree feature branch. Explicitly define the parent branch — do NOT assume current branch is correct
```bash
git checkout -b temp-test-<feature_number> mlmp-<feature_number>-<feature_name>   # the numbered ticket branch, NOT master, NOT temp-test-*
```

### Step 1a — Patch changes to test branch (if exists)
Identify if currently in a worktree or main. If in worktree, initiate **Master Patch Protocol**.
### Step 2 — Validation Loop
In the Main Checkout (on `temp-test-<feature>` branch):
1. Run `bazel run //:gazelle`
2. Run `bazel run //:format -- <targets>`
3. Run `bazel test <targets>`

### Step 3 — Sync Back
If tests pass and formatting changed:
1. Export `git diff` from Main.
2. Apply to Worktree using `git apply`.

### Step 6 — Commit in worktree (single commit, clean history)

Worktree: stage and commit. Single commit keeps history linear and Graphite-friendly.

```bash
git add -A && git commit -m "<message>"
```

---

## Subagent Rule

Subagents in worktree: do NOT run bazel test. Instead: 1) commit with `gt modify`, 2) report tests needed to orchestrator.

Orchestrator dispatches the `tester` agent — never runs bazel test directly. `tester` handles worktree detection automatically.

---

## Background

`uv` symlinks project → `.venv` for editable installs. Worktree checks out a branch, but the symlink still points to main tree source. `bazel test` inside worktree tests stale code from the main checkout, not the worktree changes.

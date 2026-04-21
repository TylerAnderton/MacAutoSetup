---
name: testing-worktree-uv
description: Worktree code untestable by bazel (`uv` symlinks stale). Use patches to transfer changes to main temp test branch, run bazel, transfer fixes back. Use when testing Python worktree.
---

<objective>
`uv` symlinks point to main checkout, not worktree. `bazel test` inside worktree tests stale code. Use Master Patch Protocol to run bazel from main checkout.
</objective>

<essential_principles>
**Core problem:** `uv` editable symlink project to `.venv`. Worktree checks out different branch, symlink still points to main tree source. `bazel test` in worktree tests stale code from main checkout.

**Fix:** Run bazel test from main checkout on temp branch mirror worktree.

**Rule:** Never merge temp branches into feature branches. Never use `gt create` for transient test branches. Always use patches to move code between worktree and main checkout.
</essential_principles>

<process>
## Master Patch Protocol

Move work between **Worktree** (coding) and **Main Checkout** (testing/formatting) to avoid Graphite metadata corruption.

### Step 1 — Export from Worktree

```bash
git diff $(gt branch info --json | jq -r '.parent') > /tmp/sync.patch
```

### Step 2 — Apply to Main Checkout

Create temp-test branch (if needed):

```bash
git checkout -b temp-test-<feature_number> mlmp-<feature_number>-<feature_name>
```

Apply patch:

```bash
git apply /tmp/sync.patch
```

### Step 3 — Execute in Main Checkout

Run in order:

```bash
bazel run //:gazelle
bazel run //:format -- <targets>
bazel test <targets>
```

### Step 4 — Capture Fixes from Main

```bash
git add -A && git diff HEAD > /tmp/fixed.patch
```

### Step 5 — Apply to Worktree

```bash
git apply /tmp/fixed.patch
```

### Step 6 — Commit in Worktree

Single commit keeps history linear and Graphite-friendly:

```bash
git add -A && git commit -m "<message>"
```
</process>

<rules>
**Rules:**
1. Never merge temp branches into feature branches
2. Never use `gt create` for transient test branches
3. Always use patches to move code between worktree and main checkout
</rules>

<subagent_rules>
**Subagent Rule:**

Subagents in worktree:
- Do NOT run bazel test
- Commit with `gt modify`
- Report tests needed to orchestrator

Orchestrator dispatches `tester` agent — never runs bazel test directly. `tester` handles worktree detection automatically.
</subagent_rules>

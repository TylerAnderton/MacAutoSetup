---
name: testing-worktree-uv
description: Runs bazel tests against Python code in a git worktree where uv editable installs point to the main checkout, causing stale test results. Creates a temp-test branch on the main checkout from the feature branch tip, runs bazel there, and merges any gazelle/format fixes back. Use when bazel testing a Python feature branch checked out as a git worktree.
---

<objective>
`uv` editable symlink points to main checkout source, not worktree. `bazel test` inside worktree tests stale code. Fix: create a temp-test branch from the feature branch on main checkout, run bazel there, merge any changes (gazelle/format fixes) back into the feature branch.
</objective>

<quick_start>
```bash
# 1. Confirm worktree is clean (all changes committed with gt modify)
git status  # from worktree

# 2. Restack downstack (find worktree paths: git worktree list --porcelain | grep -E '^(worktree|branch)')
gt restack || { echo "CONFLICT on main checkout — STOP"; exit 1; }  # non-worktree branches
(cd /path/to/ancestor-worktree && gt restack) || { echo "CONFLICT — STOP"; exit 1; }  # worktree branches
(cd /path/to/feature-worktree && gt restack) || { echo "CONFLICT — STOP"; exit 1; }

# 3. On main checkout: record current branch, then create temp-test
PREV_BRANCH=$(git branch --show-current)
git checkout -b temp-test-<feature> <feature_branch>

# 4. Run bazel
bazel run //:gazelle && bazel run //:format -- <targets> && bazel test <targets> --test_output=all

# 5. If changes: commit on temp-test, merge into feature branch via worktree
git add -A && git commit -m "chore: gazelle + format"
cd <worktree-path> && git merge temp-test-<feature> && cd <repo-root>

# 6. Return to youngest free ancestor, then delete temp-test
WORKTREE_BRANCHES=$(git worktree list --porcelain | grep '^branch' | sed 's|branch refs/heads/||')
BRANCH="$PREV_BRANCH"
while echo "$WORKTREE_BRANCHES" | grep -qx "$BRANCH"; do
    gt checkout "$BRANCH"
    BRANCH=$(gt branch info --json | jq -r '.parent')
done
gt checkout "$BRANCH"
git branch -D temp-test-<feature>
```
</quick_start>

<essential_principles>
Core problem: `uv` editable symlink projects to `.venv`. Worktree checks out different branch but symlink still points to main tree source. `bazel test` in worktree tests stale code from main checkout.

Fix: Create temp-test branch from feature branch on main checkout. Run bazel there. Merge changes back.

Rules:
1. NEVER create temp-test branches using `gt create` — use plain `git checkout -b`
2. NEVER run bazel test inside the worktree
3. ALWAYS delete the temp-test branch after each test cycle
4. ALWAYS restack the downstack (Step 2) before recreating temp-test on a new test cycle
5. On the next test cycle, restack downstack first (Step 2), then recreate temp-test fresh from the feature branch (Step 3)
</essential_principles>

<process>
<step id="1" name="ensure-committed">
All changes in the feature worktree must be committed with `gt modify` before testing. The temp-test branch is created from the feature branch tip — uncommitted worktree changes will not be included.

```bash
# In worktree: verify clean state
cd /path/to/worktree
git status  # Should be clean
```
</step>

<step id="2" name="restack-downstack">
Before creating the test branch, restack every branch in the downstack (current feature branch and all its ancestors, NOT upstack children). Parallel agent edits on parent branches must be rebased before running Gazelle and tests.

Run `gt restack` from the main checkout and from every worktree belonging to the current feature's downstack:

```bash
# From main checkout (repo root): restacks all branches NOT isolated in a worktree.
# gt restack does not traverse into worktrees — the explicit cd subshells below cover those.
gt restack || { echo "CONFLICT on main checkout — STOP"; exit 1; }

# Then for each worktree in the downstack (oldest ancestor to current feature branch).
# Discover paths via: git worktree list --porcelain | grep -E '^(worktree|branch)'
(cd /path/to/worktree-parent && gt restack) || { echo "CONFLICT in parent worktree — STOP"; exit 1; }
(cd /path/to/worktree-current && gt restack) || { echo "CONFLICT in current worktree — STOP"; exit 1; }
```

On conflict anywhere: **STOP**. Surface to orchestrator. Resolve before proceeding.
</step>

<step id="3" name="create-temp-test-branch">
From the main checkout (repo root), record the current branch then create the test branch:

```bash
cd /path/to/repo  # Main checkout, NOT the worktree
PREV_BRANCH=$(git branch --show-current)
git checkout -b temp-test-<feature_name> <feature_branch>
```

Example:
```bash
PREV_BRANCH=$(git branch --show-current)
git checkout -b temp-test-mlmp-491 mlmp-491
```

NEVER use `gt create` — this is a transient test branch that must not be registered in Graphite's stack.
</step>

<step id="4" name="run-bazel">
```bash
bazel run //:gazelle
bazel run //:format -- <targets>
bazel test <targets> --test_output=all
```
</step>

<step id="5" name="merge-fixes">
Check if gazelle/format made changes:

```bash
git status
```

If changes exist, commit on temp-test then merge into the feature branch via its worktree:
```bash
git add -A && git commit -m "chore: gazelle + format"
cd <worktree-path>
git merge temp-test-<feature_name>  # Fast-forward: temp-test is a direct ancestor
cd <repo-root>
```

If no changes: nothing to merge. Proceed to step 5.

The worktree tracking `<feature_branch>` automatically picks up any new commits (worktrees share branch refs with the main checkout).
</step>

<step id="6" name="delete-temp-test">
Cannot delete temp-test while checked out on it. Return to youngest free ancestor first:

```bash
# Walk up Graphite stack from PREV_BRANCH; skip any branch locked in a worktree
WORKTREE_BRANCHES=$(git worktree list --porcelain | grep '^branch' | sed 's|branch refs/heads/||')
BRANCH="$PREV_BRANCH"
while echo "$WORKTREE_BRANCHES" | grep -qx "$BRANCH"; do
    gt checkout "$BRANCH"
    BRANCH=$(gt branch info --json | jq -r '.parent')
done
gt checkout "$BRANCH"
git branch -D temp-test-<feature_name>
```

Next test cycle: restack downstack (Step 2), then recreate temp-test fresh from the feature branch (Step 3).
</step>
</process>

<post_submit_cleanup>
Before submitting, run the downstack restack (Step 2 of the main process) — `--restack` on `gt submit` handles the submission rebase but does not pre-align worktrees. After `gt submit --draft --no-edit --restack --branch <feature_branch>` (final PR), the feature branch is under review and no longer active development. Clean up:

<step id="1" name="delete-temp-test">
```bash
git branch -D temp-test-<feature_name>
```
</step>

<step id="2" name="checkout-youngest-free-ancestor">
Main checkout should move to the youngest ancestor branch that has been `gt submit`-ted AND is NOT currently checked out in a worktree:

```bash
# Get all branches currently locked in worktrees
WORKTREE_BRANCHES=$(git worktree list --porcelain | grep '^branch' | sed 's|branch refs/heads/||')

# Walk up the Graphite stack to find the youngest free ancestor
BRANCH=$(gt branch info --json | jq -r '.parent')
while [ -n "$BRANCH" ] && [ "$BRANCH" != "master" ] && [ "$BRANCH" != "main" ]; do
    if ! echo "$WORKTREE_BRANCHES" | grep -qx "$BRANCH"; then
        echo "Target: $BRANCH"
        gt checkout "$BRANCH"
        break
    fi
    gt checkout "$BRANCH"
    BRANCH=$(gt branch info --json | jq -r '.parent')
done
```

In a serialized workflow (no parallel worktrees), this is just `gt checkout <parent-branch>`.
</step>
</post_submit_cleanup>

<success_criteria>
- `bazel test` exits 0 on temp-test branch
- Any gazelle/format changes committed on temp-test and merged into feature branch
- temp-test branch deleted
- Feature branch worktree is clean and up to date with merged changes
- (Post-submit) Main checkout on youngest free ancestor, no stale temp-test branches
</success_criteria>

<subagent_rules>
Subagents (tester, code-writers, bug-fixers) in worktrees:
- NEVER run bazel test — commit work with `gt modify` and report to orchestrator
- Report: bazel targets to test + worktree path

Orchestrator runs this skill directly on the main checkout. No subagent handles the temp-test lifecycle.
</subagent_rules>

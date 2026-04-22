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

# 2. On main checkout: create temp-test branch from feature branch tip
git checkout -b temp-test-<feature> <feature_branch>

# 3. Run bazel
bazel run //:gazelle && bazel run //:format -- <targets> && bazel test <targets> --test_output=all

# 4. If changes: commit + merge back; otherwise just checkout feature branch
git add -A && git commit -m "chore: gazelle + format"
git checkout <feature_branch> && git merge temp-test-<feature>

# 5. Delete temp-test branch
git branch -d temp-test-<feature>
```
</quick_start>

<essential_principles>
Core problem: `uv` editable symlink projects to `.venv`. Worktree checks out different branch but symlink still points to main tree source. `bazel test` in worktree tests stale code from main checkout.

Fix: Create temp-test branch from feature branch on main checkout. Run bazel there. Merge changes back.

Rules:
1. NEVER create temp-test branches using `gt create` — use plain `git checkout -b`
2. NEVER run bazel test inside the worktree
3. ALWAYS delete the temp-test branch after each test cycle
4. On the next test cycle, recreate temp-test fresh from the feature branch
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

<step id="2" name="create-temp-test">
From the main checkout (repo root), create a test branch at the same tip as the feature branch:

```bash
cd /path/to/repo  # Main checkout, NOT the worktree
git checkout -b temp-test-<feature_name> <feature_branch>
```

Example:
```bash
git checkout -b temp-test-mlmp-491 mlmp-491
```

NEVER use `gt create` — this is a transient test branch that must not be registered in Graphite's stack.
</step>

<step id="3" name="run-bazel">
```bash
bazel run //:gazelle
bazel run //:format -- <targets>
bazel test <targets> --test_output=all
```
</step>

<step id="4" name="merge-fixes">
Check if gazelle/format made changes:

```bash
git status
```

If changes exist:
```bash
git add -A && git commit -m "chore: gazelle + format"
git checkout <feature_branch>
git merge temp-test-<feature_name>  # Fast-forward: test branch is a direct ancestor
```

If no changes:
```bash
git checkout <feature_branch>
```

The worktree tracking `<feature_branch>` automatically picks up any new commits (worktrees share branch refs with the main checkout).
</step>

<step id="5" name="delete-temp-test">
```bash
git branch -d temp-test-<feature_name>
```

Next test cycle: recreate temp-test fresh from the feature branch (Step 2).
</step>
</process>

<post_submit_cleanup>
After `gt submit` (final PR), the feature branch is under review and no longer active development. Clean up:

<step id="1" name="delete-temp-test">
```bash
git branch -d temp-test-<feature_name>
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
Subagents in worktrees:
- NEVER run bazel test
- Commit with `gt modify`
- Report tests needed to orchestrator

Orchestrator creates temp-test branch and dispatches `tester` agent to main checkout — never runs bazel test directly in the worktree.
</subagent_rules>

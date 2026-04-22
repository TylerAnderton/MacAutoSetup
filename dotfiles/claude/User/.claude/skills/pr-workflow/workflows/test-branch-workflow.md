---
name: test-branch-workflow
description: Creates a temporary test branch on the main checkout from a feature branch tip to run bazel in uv/bazel environments where worktree symlinks are stale. Use when bazel tests or gazelle must run against the main checkout rather than a feature worktree.
---

<objective>
Test changes from a feature worktree using main checkout, where `uv` and `bazel` require the main checkout environment. Creates a temp-test branch, runs bazel, and merges any auto-fixes back into the feature branch.
</objective>

<quick_start>
```bash
PREV_BRANCH=$(git branch --show-current)
git checkout -b temp-test-<feature> <feature_branch>
bazel run //:gazelle && bazel run //:format -- <targets> && bazel test <targets>
# If changes: commit on temp-test, then merge via worktree
git add -A && git commit -m "chore: gazelle + format"
cd <worktree-path> && git merge temp-test-<feature> && cd <repo-root>
# Return to youngest free ancestor, then delete
WORKTREE_BRANCHES=$(git worktree list --porcelain | grep '^branch' | sed 's|branch refs/heads/||')
BRANCH="$PREV_BRANCH"
while echo "$WORKTREE_BRANCHES" | grep -qx "$BRANCH"; do gt checkout "$BRANCH" && BRANCH=$(gt branch info --json | jq -r '.parent'); done
gt checkout "$BRANCH" && git branch -d temp-test-<feature>
```
</quick_start>

<context>
Worktrees have stale `uv` symlinks — bazel sees old source. Fix: create a temp-test branch from the feature branch tip on main checkout, run bazel there, merge any auto-fixes back into the feature branch.
</context>

<protocol>
<step id="1" name="confirm-committed">
All work must be committed in the worktree with `gt modify` before creating the test branch.
</step>

<step id="2" name="create-temp-test">
```bash
cd /path/to/repo  # Main checkout (NOT the worktree)
PREV_BRANCH=$(git branch --show-current)
git checkout -b temp-test-<feature> <feature_branch>
```

NEVER use `gt create` — this branch must not enter the Graphite stack.
</step>

<step id="3" name="run-bazel">
```bash
bazel run //:gazelle
bazel run //:format -- <targets>
bazel test <targets> --test_output=all
```
</step>

<step id="4" name="merge-fixes">
```bash
git status  # Check for gazelle/format changes
# If changes: commit on temp-test, merge into feature branch via worktree
git add -A && git commit -m "chore: gazelle + format"
cd <worktree-path>
git merge temp-test-<feature>  # Fast-forward
cd <repo-root>
# If no changes: nothing to merge, proceed to step 5
```
</step>

<step id="5" name="delete-branch">
Return to youngest free ancestor first (can't delete a branch while checked out on it; parallel worktrees may lock immediate parents):

```bash
WORKTREE_BRANCHES=$(git worktree list --porcelain | grep '^branch' | sed 's|branch refs/heads/||')
BRANCH="$PREV_BRANCH"
while echo "$WORKTREE_BRANCHES" | grep -qx "$BRANCH"; do
    gt checkout "$BRANCH"
    BRANCH=$(gt branch info --json | jq -r '.parent')
done
gt checkout "$BRANCH"
git branch -d temp-test-<feature>
```

Recreate from the feature branch tip on the next test cycle.
</step>
</protocol>

<success_criteria>
- `bazel test` exits 0
- Any gazelle/format changes committed and merged into feature branch
- temp-test branch deleted
- Main checkout on youngest free ancestor (feature branch remains in worktree)
</success_criteria>

<cleanup_after_submit>
After `gt submit --draft --no-edit --restack --branch <feature_branch>`: checkout the youngest ancestor branch that (a) has been gt-submitted and (b) is not checked out in a worktree, then delete temp-test branch. See `skills/testing-worktree-uv/SKILL.md` for the full cleanup procedure.
</cleanup_after_submit>

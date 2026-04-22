# Cleanup Worktree

<objective>Remove a completed worktree and its branch. After final `gt submit`, return main checkout to the youngest free ancestor branch.</objective>

<process>

**Step 1: Remove the worktree**

From the repo root:

```bash
git worktree remove .worktrees/<name>
```

Example:
```bash
git worktree remove .worktrees/mlmp-491-subtask
```

Verify removal:
```bash
git worktree list  # Should no longer show the worktree
```

**Step 2: Delete the feature branch**

If the branch has been merged or submitted and is no longer needed:

```bash
gt branch delete <branch-name>
```

Or if already gone on remote (merged via PR):

```bash
git branch -d <branch-name>  # Safe delete (requires merged)
```

**Step 3: Delete the temp-test branch (if it exists)**

```bash
git branch -d temp-test-<feature>
```

If it exists but hasn't been merged (e.g., you're doing early cleanup), force delete:

```bash
git branch -D temp-test-<feature>
```

</process>

<post_submit_checkout>

## After `gt submit` — Find the Youngest Free Ancestor

After final `gt submit`, the submitted feature is under review. Main checkout should move to the youngest ancestor in the Graphite stack that:
- Has already been submitted via `gt submit`
- Is NOT currently checked out in a worktree (locked)

```bash
# Get all branches currently locked in worktrees
WORKTREE_BRANCHES=$(git worktree list --porcelain | grep '^branch' | sed 's|branch refs/heads/||')

# Walk up the Graphite stack until we find a free branch
BRANCH=$(gt branch info --json | jq -r '.parent')
while [ -n "$BRANCH" ] && [ "$BRANCH" != "master" ] && [ "$BRANCH" != "main" ]; do
    if ! echo "$WORKTREE_BRANCHES" | grep -qx "$BRANCH"; then
        echo "Checking out: $BRANCH"
        gt checkout "$BRANCH"
        break
    fi
    # Branch is locked in a worktree — step up one more generation
    gt checkout "$BRANCH"
    BRANCH=$(gt branch info --json | jq -r '.parent')
done
```

In a serialized workflow (no parallel worktrees), this is simply:
```bash
gt checkout <parent-branch>
```

After checking out the free ancestor, the submitted feature branch's worktree (if any) can be safely removed and the temp-test branch deleted.

</post_submit_checkout>

<success_criteria>

✓ Worktree removed (not in `git worktree list`)
✓ Feature branch deleted (if merged/submitted)
✓ temp-test branch deleted
✓ Main checkout on youngest free ancestor

</success_criteria>

<troubleshooting>

**"Can't remove worktree — it has changes"**
→ Subagent didn't commit changes. Commit with `gt modify`, or discard:
```bash
cd .worktrees/<name>
git stash
cd ../..
git worktree remove .worktrees/<name>
```

**"Can't delete branch — not fully merged"**
→ If intentional, force delete:
```bash
git branch -D <branch-name>
```

**"All ancestor branches are locked in worktrees"**
→ Rare under parallel development. Checkout master/main as fallback:
```bash
git checkout master
```

</troubleshooting>



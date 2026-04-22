<objective>Remove a completed worktree and its branch. After final `gt submit`, return main checkout to the youngest free ancestor branch.</objective>

<quick_start>
```bash
git worktree remove .worktrees/<name>
gt branch delete <branch-name>
git branch -d temp-test-<feature>   # if exists
```
</quick_start>

<process>
<step id="1" name="remove-worktree">
From the repo root:

```bash
git worktree remove .worktrees/<name>
```

Verify:
```bash
git worktree list  # Should no longer show the worktree
```
</step>

<step id="2" name="delete-feature-branch">
If the branch has been merged or submitted and is no longer needed:

```bash
gt branch delete <branch-name>
```

Or if already gone on remote (merged via PR):

```bash
git branch -d <branch-name>  # Safe delete (requires merged)
```
</step>

<step id="3" name="delete-temp-test">
```bash
git branch -d temp-test-<feature>
```

If it exists but hasn't been merged (early cleanup), force delete:

```bash
git branch -D temp-test-<feature>
```
</step>
</process>

<post_submit_checkout>
After `gt submit`, the submitted feature is under review. Main checkout should move to the youngest ancestor in the Graphite stack that has been `gt submit`-ted AND is NOT currently checked out in a worktree.

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
    gt checkout "$BRANCH"
    BRANCH=$(gt branch info --json | jq -r '.parent')
done
```

In a serialized workflow (no parallel worktrees), this is simply `gt checkout <parent-branch>`.
</post_submit_checkout>

<success_criteria>
- Worktree removed (not in `git worktree list`)
- Feature branch deleted (if merged/submitted)
- temp-test branch deleted
- Main checkout on youngest free ancestor
</success_criteria>

<troubleshooting>
<error case="locked-worktree">
Subagent didn't commit changes. Commit with `gt modify`, or discard:

```bash
cd .worktrees/<name>
git stash
cd ../..
git worktree remove .worktrees/<name>
```
</error>

<error case="branch-not-merged">
If intentional, force delete:

```bash
git branch -D <branch-name>
```
</error>

<error case="all-ancestors-locked">
Rare under parallel development. Checkout master/main as fallback:

```bash
git checkout master
```
</error>
</troubleshooting>

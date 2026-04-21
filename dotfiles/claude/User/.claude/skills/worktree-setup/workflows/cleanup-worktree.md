# Cleanup Worktree

<objective>Remove completed worktree and optionally delete its branch.</objective>

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

**Step 2: (Optional) Delete the branch**

If the branch has been merged and is no longer needed:

```bash
gt branch delete <branch-name>
```

Example:
```bash
gt branch delete mlmp-491-subtask
```

Or, if the branch is already gone on remote (e.g., merged via PR):

```bash
git branch -d <branch-name>  # Safe delete (requires merged)
```

**Step 3: Verify cleanup**

```bash
git branch -a  # Check branch is gone locally and remotely
git worktree list  # Confirm no stale worktrees
```

</process>

<success_criteria>

✓ Worktree removed (not in `git worktree list`)
✓ Branch deleted (optional, but recommended if merged)
✓ No stale worktrees or branches left behind

</success_criteria>

<troubleshooting>

**"Can't remove worktree — it has changes"**
→ Subagent didn't commit changes. Either commit them with `gt modify`, or stash them first:
```bash
cd .worktrees/<name>
git stash  # Discard changes
cd ../..
git worktree remove .worktrees/<name>
```

**"Can't delete branch — not fully merged"**
→ If intentional, use force delete:
```bash
git branch -D <branch-name>
```

</troubleshooting>


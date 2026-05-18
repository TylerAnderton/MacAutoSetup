---
name: git-graphite-recovery
description: Conflict resolution, branch rescue, and recovery procedures for Graphite
---

<objective>
Handle problematic scenarios: merge conflicts, untracked branches, diverged branches, and parallel branch issues.
</objective>

## Conflict Resolution

When `gt sync` or `gt create` encounters conflicts:

Step 1: Identify conflicting files
```bash
git status
```

Step 2: Open conflicting files and resolve manually
Look for conflict markers:
```<<<<<<< HEAD
your changes
=======
their changes
>>>>>>> branch-name
```

Step 3: After resolving, stage the files
```bash
git add <resolved-file1> <resolved-file2>
```

Step 4: Continue or abort
```bash
gt continue  # Resume the operation
# OR
gt abort     # Cancel and revert to previous state
```

## Recovery Procedures

### Rescuing an Untracked Branch

A branch exists locally but not in Graphite's metadata:

```bash
gt track --parent <parent-branch>
```

Example: Rescue `feat/my-feature` that was created outside Graphite:
```bash
gt track --parent main
```

### Rescuing a Diverged Branch

When your branch has diverged from remote (local and remote have diverged):

**Option 1: Rebase (preferred for clean history)**
```bash
gt fetch origin
git rebase origin/<branch-name>
```

**Option 2: Force push (use only if you understand consequences)**
```bash
git push --force-with-lease origin <branch-name>
```

### Parallel Branches Squash Approach

When you accidentally created two branches from the same base in parallel:

1. Identify the branches:
```bash
gt stack
```

2. Squash commits on the second branch into a single commit:
```bash
gt checkout <second-branch>
gt modify -a -m "squashed: combined changes"
```

3. If the branches are independent features, merge them:
```bash
gt merge <first-branch>
gt modify -a -m "merged: combined parallel work"
```

### Clearing Closed-PR Cache

When Graphite's branch tracking becomes stale after PRs are closed:

```bash
gt branch -D <closed-branch-name>
gt sync
```

## Recovery Quick Reference

| Problem | Solution |
|---------|----------|
| Untracked branch | `gt track --parent <parent>` |
| Diverged from remote | `git rebase origin/<branch>` |
| Parallel branch conflict | Squash with `gt modify -a` |
| Stale closed-PR cache | `gt branch -D <name>` then `gt sync` |
| Lost commits | `git reflog` to find, `git cherry-pick` to recover |
| Conflict during sync | Resolve files → `git add` → `gt continue` |

## Emergency Rollback

To completely reset to a known good state:

```bash
# See recent operations
git reflog

# Reset to specific point
git reset --hard HEAD@{N}
```

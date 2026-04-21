---
name: git-graphite-command-reference
description: Complete reference for all Graphite (gt) commands
---

<objective>
Provide a comprehensive command reference for Graphite (gt) operations.
</objective>

## Branch Management

| Command | Description |
|---------|-------------|
| `gt branch` | List all branches tracked by Graphite |
| `gt branch -D <name>` | Delete a branch (including closed PR branches) |
| `gt checkout <branch>` | Switch to an existing branch |
| `gt create <name> -am "msg"` | Create new branch with initial commit (ONLY way to create) |
| `gt track --parent <branch>` | Add untracked branch to stack with parent |

## Commit Operations

| Command | Description |
|---------|-------------|
| `gt modify -a -m "msg"` | Amend last commit with new message (preferred over git commit) |
| `gt modify -a -- amend` | Amend without changing message |
| `gt commit -m "msg"` | Create new commit (use `gt modify` instead when possible) |

## Sync Operations

| Command | Description |
|---------|-------------|
| `gt sync` | Sync current branch with its remote tracking branch |
| `gt sync --all` | Sync entire stack from root |
| `gt fetch origin` | Fetch remote changes without rebasing |

## Stack Operations

| Command | Description |
|---------|-------------|
| `gt stack` | Display full stack tree with PR status |
| `gt log` | Show commit history for current branch |
| `gt merge <branch>` | Merge another branch into current |
| `gt stack --shallow` | Show condensed stack view |

## Conflict Resolution

| Command | Description |
|---------|-------------|
| `gt continue` | Resume operation after resolving conflicts |
| `gt abort` | Cancel current operation and revert |
| `gt status` | Show conflict status |

## PR Management

| Command | Description |
|---------|-------------|
| `gt submit` | Submit current branch as PR |
| `gt update` | Update PR with latest changes |
| `gt downstack` | Show branches below current |
| `gt upstack` | Show branches above current |

## Workflow Command Sequence

### Create Branch
```bash
git branch --show-current  # Verify
gt checkout <parent>
gt create <name> -am "msg"
```

### Add Commit
```bash
git branch --show-current  # Verify
bazel run //:gazelle
git add .
gt modify -a -m "msg with Co-Authored-By: ..."
```

### Sync Stack
```bash
gt sync        # Single branch
gt sync --all  # Entire stack
```

### Resolve Conflict
```bash
# Edit conflicting files
git add <resolved-files>
gt continue    # or gt abort
```

## Notes

- **Never use** `git checkout -b` or `git switch -c` — use only `gt create`
- **Never use** GitHub "Update branch" button — creates merge commits
- **Stacking rule**: Create branches sequentially, never parallel from same base
- **AI reviewer**: Intentionally skipped for Graphite submissions

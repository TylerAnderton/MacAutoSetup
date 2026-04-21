---
name: git-graphite-daily-ops
description: Daily branch creation, committing, and sync workflows for Graphite
---

<objective>
Cover the primary operations needed day-to-day: creating branches, committing changes, and syncing your stack.
</objective>

## Creating a New Feature Branch

**Critical: Use `gt create` exclusively** — never `git checkout -b` or `git switch -c`

Step 1: Verify current branch
```bash
git branch --show-current
```

Step 2: Switch to the parent branch (usually main or master)
```bash
gt checkout main
```

Step 3: Create the new branch with initial commit
```bash
gt create {project-name}/{feature-description} -am "Initial commit: describe feature"
```

Example:
```bash
gt checkout main
gt create core-api/add-users-endpoint -am "Initial commit: add users endpoint"
```

## Committing Changes

**Critical: Use `gt modify` for commits** — never `git commit` directly

Step 1: Verify current branch
```bash
git branch --show-current
```

Step 2: Run Bazel to update dependencies
```bash
cd /Users/tyleranderton/Repositories/tractian-ai
bazel run //:gazelle
```

Step 3: Check what changed
```bash
git status
```

Step 4: Stage and commit using gt modify
```bash
gt modify -a -m "commit message here"
```

**Include Co-Authored-By trailer** in your commit message:
```
feat: add users endpoint

Added REST endpoint for user CRUD operations

Co-Authored-By: Your Name <your.email@example.com>
```

Step 5: Include BUILD.bazel changes if gazelle generated them
```bash
git add BUILD.bazel
gt modify -a -- amend
```

## Syncing Your Stack

**Sync at the start of every session** and **before submitting** a PR

Sync current branch only:
```bash
gt sync
```

Sync entire stack (from root of stack):
```bash
gt sync --all
```

**Never use the GitHub "Update branch" button** — it creates merge commits that pollute history.

## Daily Workflow Summary

```
# Start of day
git branch --show-current  # Verify where you are
gt checkout main
gt sync                     # Pull latest
gt checkout your-branch     # Return to work

# Before submitting
gt sync                     # Ensure clean with remote
git branch --show-current  # Final verification
```

## Subagent Rules

When operating as a subagent:

- Never create branches — only use `gt modify` to add commits
- Always verify branch before operating
- If on a `temp-test-*` branch, exit and request the orchestrator provide the correct branch
- Include `Co-Authored-By` trailer in all commits

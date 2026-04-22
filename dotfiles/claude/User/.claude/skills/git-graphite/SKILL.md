---
name: git-graphite
description: Consolidated skill for Graphite (gt) branch management, stacking, and recovery workflows in the tractian-ai repository
---

<objective>
Enable safe, consistent branch management and commit workflows using Graphite (gt) in the tractian-ai repository. This skill consolidates git-branch-management and graphite protocols into a single router pattern skill.
</objective>

<essential_principles>
- `gt create` is the ONLY way to create branches — never use `git checkout -b` or `git switch -c`
- Branch naming convention: `{project-name}/{feature-description}`
- Always verify current branch with `git branch --show-current` before any operation
- Run `bazel run //:gazelle` before every commit; include BUILD.bazel changes in commit
- Include `Co-Authored-By` trailer in all commits
- AI reviewer is intentionally skipped for Graphite submissions
- Orchestrator sessions often run on throwaway `temp-test-*` branches — always verify before operating
</essential_principles>

<intake>
What are you trying to accomplish?

1. **Create/switch branches** — Creating new feature branches or switching between existing ones
2. **Commit changes** — Adding commits to the current branch
3. **Sync stack** — Updating your local stack with remote changes
4. **Resolve conflicts** — Handling merge conflicts or rescuing branches
5. **Recover from issues** — Fixing diverged branches, untracked branches, or parallel branch problems
6. **Quick reference** — Looking up a specific gt command
</intake>

<routing>
If you are uncertain what to do, start by running `git branch --show-current` to verify your current branch.

<route name="create-switch">
**Creating or switching branches**
- See: `workflows/daily-ops.md` — "Creating a New Feature Branch" section
</route>

<route name="commit">
**Adding commits to current branch**
- See: `workflows/daily-ops.md` — "Committing Changes" section
</route>

<route name="sync">
**Syncing your stack with remote**
- See: `workflows/daily-ops.md` — "Syncing Your Stack" section
</route>

<route name="conflicts">
**Resolving merge conflicts or using gt continue/abort**
- See: `workflows/recovery.md` — "Conflict Resolution" section
</route>

<route name="rescue">
**Rescuing untracked branches, diverged branches, or parallel branches**
- See: `workflows/recovery.md` — "Recovery Procedures" section
</route>

<route name="reference">
**Quick command lookup**
- See: `references/gt-command-reference.md`
</route>
</routing>

<quick_reference>
| Command | Description |
|---------|-------------|
| `gt branch` | List all branches in the stack |
| `gt create <name> -am "msg"` | Create branch with initial commit |
| `gt checkout <branch>` | Switch to existing branch |
| `gt modify -a -m "msg"` | Amend last commit (use `git commit` **only** in temp-test branches) |
| `gt sync` | Sync current branch with remote |
| `gt sync --all` | Sync entire stack |
| `gt continue` | Resume after resolving conflicts |
| `gt abort` | Cancel current operation |
| `gt track --parent <branch>` | Add untracked branch to stack |
| `gt log` | Show commit history |
| `gt stack` | Show full stack tree |
</quick_reference>

<context>
Repository: /Users/tyleranderton/Repositories/tractian-ai
Tool: Graphite (gt) — manages stacked PRs
Stacking rule: Sequential creation required — never create two branches from the same base in parallel
Never use: GitHub "Update branch" button (creates merge commits)
</context>

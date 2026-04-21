---
name: git-branch-management
description: "Rules for all branch and commit operations in tractian-ai. Invoke when creating a branch, committing, or performing any git branching operation. gt is the only authorized tool for branch creation — never git checkout -b."
---

# Git Branch Management

## Cardinal Rules

- **Branches created with `gt create`** — never `git checkout -b`, `EnterWorktree`, other tools
- **Worktree branches stacked on current feature branch** — never master/main
- **Format:** `{project-name}/{feature-description}` (e.g. `metrics-anomalies/mlmp-491-fix-chart`)

## Creating a Branch

**The orchestrator session is NOT on the feature branch. When using `testing-worktree-uv` patch workflow, changes transfer via patches, no temp-test branches created.**

```bash
# Step 0: Confirm current branch — do NOT assume
git branch --show-current

# Step 1: Switch to the feature branch (never base on temp-test-* or master)
gt checkout metrics-anomalies/mlmp-491

# Step 2: Create branch, stage everything, commit in one step
gt create metrics-anomalies/mlmp-491-subtask -am "feat: description"
```

`gt create` stacks on whichever branch is currently checked out — so always verify first.

## Rescuing Untracked Branch

Branch created without `gt` (non-gt tool)? Register immediately before work:

```bash
gt track --parent <parent-branch>
```

## Committing

Include Co-Authored-By trailer:

```bash
# Amend current commit (preferred — keeps history clean)
gt modify -a -m "$(cat <<'EOF'
fix: description

Co-Authored-By: <current_model_name>
EOF
)"

# Add a new commit
gt modify -cam "fix: description"
# Then amend to add trailer: gt modify -a
```

**Before every commit:** Run `bazel run //:gazelle`, include `BUILD.bazel` changes.

## Operation Reference

| Instead of | Use |
|------------|-----|
| `git checkout -b <branch>` | `gt create <branch> -am "msg"` |
| `git commit` | `gt modify -cam "msg"` |
| `git commit --amend` | `gt modify -a` |
| `git rebase` | `gt restack` |
| `git pull` | `gt sync` |
| `git reset --hard` | `gt undo` |

## Subagent Rules

Subagents in worktrees must:

1. Never create branches—orchestrator creates + registers before dispatch
2. Work only on given branch
3. `gt modify` for commits, never `git commit`
4. Need sub-branch? Stop, ask orchestrator
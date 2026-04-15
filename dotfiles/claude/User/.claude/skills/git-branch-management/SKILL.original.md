---
name: git-branch-management
description: "Rules for all branch and commit operations in tractian-ai. Invoke when creating a branch, committing, or performing any git branching operation. gt is the only authorized tool for branch creation — never git checkout -b."
---

# Git Branch Management

## Cardinal Rules

- **All branches created with `gt create`** — never `git checkout -b`, `EnterWorktree`, or any other tool
- **All worktree branches stacked on the current numbered feature branch** — never on master/main
- **Branch naming:** `{project-name}/{feature-description}` (e.g. `metrics-anomalies/mlmp-491-fix-chart`)

## Creating a Branch

```bash
# Create branch, stage everything, commit in one step
gt create metrics-anomalies/my-branch -am "feat: description"
```

`gt create` stacks on whatever branch is currently checked out. To stack on a specific parent:

```bash
gt checkout metrics-anomalies/mlmp-491   # current feature branch
gt create metrics-anomalies/mlmp-491-subtask -am "feat: initial"
```

## Rescuing an Untracked Branch

If a branch was accidentally created without `gt` (any non-gt tool), register it immediately before further work:

```bash
gt track --parent <parent-branch>
```

## Committing

Always include the Co-Authored-By trailer:

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

**Mandatory before every commit:** Run `bazel run //:gazelle` and include any `BUILD.bazel` changes.

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

Subagents dispatched to work in worktrees must:

1. Never create branches — the orchestrator creates and registers all branches before dispatching
2. Work only on the branch they were given
3. Use `gt modify` for commits (never `git commit`)
4. If they need to create a sub-branch, stop and ask the orchestrator

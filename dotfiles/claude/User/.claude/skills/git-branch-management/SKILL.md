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

```bash
# Create branch, stage everything, commit in one step
gt create metrics-anomalies/my-branch -am "feat: description"
```

`gt create` stacks on current branch. To stack on specific parent:

```bash
gt checkout metrics-anomalies/mlmp-491   # current feature branch
gt create metrics-anomalies/mlmp-491-subtask -am "feat: initial"
```

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
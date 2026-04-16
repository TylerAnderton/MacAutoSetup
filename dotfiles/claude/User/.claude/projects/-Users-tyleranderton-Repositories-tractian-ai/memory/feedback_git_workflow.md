---
name: Git/Worktree Workflow Rules
description: Correct branch creation and worktree procedures to prevent Graphite tracking issues and broken stack submissions
type: feedback
---

Create all branches with `gt create`, never `git checkout -b` or `EnterWorktree`. Except temp-test branches (throwaway test artifacts) — use plain `git checkout -b`, untracked intentionally.

**Why:** `git checkout -b` bypass = broken `gt restack`, `gt submit`. Caused broken PR stacks, stack conflicts.

**How to apply:**
- Orchestrator: all branches on main + `gt create` before subagent dispatch
- Subagents: no branch creation. Commit to given branch w/ `gt modify`
- Worktrees: base on feature branch (e.g. `metrics-anomalies/mlmp-491`), never `master` or `temp-test-*`
- Orchestrator session is typically on a `temp-test-*` branch — NOT the feature branch. Always `gt checkout <feature-branch>` explicitly before any `gt create`. Never assume current branch is the correct base.
- Never use term "main checkout" — ambiguous. Use "repo root" + absolute path instead.
- Use `worktree-setup` for worktrees, `git-branch-management` for branch/commit rules

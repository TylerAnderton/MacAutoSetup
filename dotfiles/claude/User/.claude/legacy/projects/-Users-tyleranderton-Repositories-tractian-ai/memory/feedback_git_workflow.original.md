---
name: Git/Worktree Workflow Rules
description: Correct branch creation and worktree procedures to prevent Graphite tracking issues and broken stack submissions
type: feedback
---

All branches must be created with `gt create`, never `git checkout -b` or `EnterWorktree`. Temp-test branches (disposable testing artifacts) are the only exception — those use plain `git checkout -b` and are intentionally untracked.

**Why:** Raw `git checkout -b` bypasses Graphite's stack tracking, breaking `gt restack` and `gt submit`. Caused repeated issues with broken PR stacks and stack conflicts.

**How to apply:**
- Orchestrator creates all branches on main checkout with `gt create` before dispatching subagents
- Subagents never create branches — they commit to the branch they're given using `gt modify`
- Worktrees always base on the current numbered feature branch (e.g. `metrics-anomalies/mlmp-491`), never on `master`
- Use `worktree-setup` skill for worktree setup; `git-branch-management` for all branch/commit rules

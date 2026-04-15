---
name: Always parallelize with subagents
description: Default to subagent-driven development without asking — never prompt the user to choose between subagent vs inline execution
type: feedback
---

Use `superpowers:subagent-driven-development` executing plans. No ask user—default parallel subagents. Invoke `superpowers:dispatching-parallel-agents` + `superpowers:using-git-worktrees`.

**Why:** Max efficiency multi-task. User said no asking every time. Parallelization = automatic default.

**How to apply:** writing-plans done + offers options? Skip question. Invoke `superpowers:subagent-driven-development` immediately. Same any multi-task (tasks independent).
---
name: Always parallelize with subagents
description: Default to subagent-driven development without asking — never prompt the user to choose between subagent vs inline execution
type: feedback
---

Always use subagent-driven development (superpowers:subagent-driven-development) when executing implementation plans. Do not ask the user which execution mode to use — just default to parallel subagents. Invoke `superpowers:dispatching-parallel-agents` + `superpowers:using-git-worktrees`.

**Why:** Maximize efficiency on multi-task work. User explicitly stated they don't want to be asked every time. Parallelization should be the automatic, assumed default.

**How to apply:** Whenever writing-plans completes and offers execution options, skip the question and immediately invoke superpowers:subagent-driven-development. Same applies to any multi-task work where tasks are independent.

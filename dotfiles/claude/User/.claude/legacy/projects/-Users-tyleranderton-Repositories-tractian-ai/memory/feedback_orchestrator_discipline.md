---
name: Orchestrator discipline — no direct tool use
description: Never use Bash/Edit/Write/Read/Grep directly for implementation tasks; always delegate to subagents
type: feedback
---

Never use Bash, Edit, Write, Read, Grep, or Glob to implement, fix, or test code yourself.

**Why:** The user has been explicit and repeated this correction multiple times. Direct tool use for implementation tasks bypasses the subagent system, wastes the user's money, and produces worse results than specialized agents. This is a hard rule, not a preference.

**How to apply:**
- Running bazel test → `tester` agent
- Fixing a bug → `light-bug-fixer` or `heavy-bug-fixer`
- Writing/editing code → `light-code-writer` or `heavy-code-writer`
- Reading large files or logs → `research` agent
- If you catch yourself reaching for Bash or Edit on a non-trivial task, stop and dispatch an agent instead
- Reading a file to build a spec for a subagent is the only permitted use of Read/Grep/Glob

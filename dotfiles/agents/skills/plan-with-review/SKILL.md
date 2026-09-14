---
name: plan-with-review
description: Use before implementing any non-trivial coding task (new feature, bugfix with a non-obvious root cause, multi-file refactor). Clarifies requirements and delegation preferences up front, keeps the plan to spec/requirements only (no code), and copies the approved plan to Obsidian once it's approved. Skip for trivial one-off fixes.
---

# Plan With Review

## When to use

Before starting any non-trivial coding task. Skip for trivial one-off fixes (typo, single-line change, config tweak) — use judgment.

## Steps

1. **Dialogue.** Clarify the task's requirements with the user — ask whatever is actually unclear, not just the fixed list below. In addition, always ask:
   - Whether to delegate tasks to subagents.
   - The Obsidian vault path and folder to copy the approved plan into.

2. **Write the plan as spec/requirements only.** No code, no solutions — describe what's needed and why, not how to implement it. Do not use `superpowers:writing-plans` for this step even if installed: its task format embeds code per task, which is the opposite of what's wanted here.

3. **Proceed to plan-mode exit as normal.** The installed Plannotator plugin already intercepts plan-mode exit and opens the plan for human approval — no separate manual Plannotator invocation needed for this step specifically. This does not apply to code review or the RED-test review in `tdd-with-review`, which are separate, still-required checkpoints later.

4. **Once approved, copy the plan file to the Obsidian destination** collected in step 1:
   ```bash
   mkdir -p "<vault-path>/<folder>" && cp "<plan-file>" "<vault-path>/<folder>/"
   ```

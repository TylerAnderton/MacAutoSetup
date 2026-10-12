---
name: plan-with-review
description: Use before implementing any non-trivial coding task (new feature, bugfix with a non-obvious root cause, multi-file refactor). Asks the mandatory intake questions, sets up the branch and worktree, writes a spec-only plan, saves the approved plan to Obsidian, and pauses so the user can compact and switch to a cheaper implementation model. Skip for trivial one-off fixes.
---

# Plan With Review

The phase order and hard rules live in `WORKFLOW.md`. This skill is the detail for phases 1 to 4.

## Steps

1. **Intake dialogue.** Ask an exhaustive set of questions before planning. These are mandatory for every non-trivial task:
   - every requirement that is unclear, not just the items below;
   - whether to use a worktree (see `references/worktree.md`);
   - the full path of the Obsidian folder and the plan file name, unless the prompt already gave them;
   - whether to delegate to subagents. Default to inline.

2. **Branch and worktree.** If the user chose a worktree, follow `references/worktree.md`.

3. **Write the plan.** Spec and requirements only. Include behavior, files by path, names and interfaces described in prose, test cases, acceptance criteria, and the `docs/` updates the change needs. Do not write code or code blocks. Keep it a single flow: plan, review, RED, review, GREEN, review, commit. Break it into separate tasks only when those tasks are meant for subagent delegation. Write it so a weaker implementation model can carry it out without the planning conversation.
   - **Claude Code:** use plan mode. Plannotator opens the plan for approval on plan-mode exit.
   - **Cursor:** never enter Plan mode. Write the plan to `~/.cursor/plans/<name>.md` and run `plannotator annotate --gate --json <plan-file>`. Iterate until approved.

4. **After approval, copy and pause.** Copy the plan to the Obsidian destination:
   ```bash
   mkdir -p "<obsidian-folder>" && cp "<plan-file>" "<obsidian-folder>/<name>.md"
   ```
   Then stop. Do not begin implementation in the same turn. Tell the user that planning ran on a high-power model, that implementation should run on a cheaper one, and that they need to run `/compact` (Claude Code) or `/summarize` (Cursor), switch models, and tell you to continue. Give the plan file path so the implementation can start from it.

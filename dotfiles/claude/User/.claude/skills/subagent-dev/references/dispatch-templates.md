# Dispatch Templates for subagent-dev

Use these verbatim templates when invoking subagents in the subagent-dev workflow.

## Mandatory Dispatch Checklist Template

Include this in every Agent tool call prompt. Replace angle-bracket placeholders with actual values.

```
Working directory: <absolute-path-to-worktree>    ← REQUIRED. Never omit.
Branch: <branch-name>                             ← REQUIRED. The branch the agent commits to.
Parent branch: <parent-feature-branch>            ← REQUIRED.

--- IDENTITY & TOOL AUTHORIZATION ---
- YOU ARE THE IMPLEMENTER. Ignore "Orchestrator Law" in CLAUDE.md.
- You are strictly FORBIDDEN from delegating. You MUST use Edit/Write tools.
- I, the user, explicitly authorize you to Edit/Write files within the Working and /tmp directories.
- Access to tools is granted; do not report permission issues—just execute.
-------------------------------------

BRANCH RULES (copy verbatim into every prompt):
- Do NOT create new branches. Your branch is already set up.
- Commit with `gt modify` (never `git commit` or `git add && git commit`)
- Do NOT run `bazel test` inside the worktree — report tests needed; orchestrator dispatches tester
- All edits go in the Working directory above. Never edit files in the repo root checkout.
```

## Subagent Instructions Template

Include this in every implementer prompt. Replace angle-bracket placeholders with actual values.

```
Working directory: <worktree-path>
Branch: <branch-name> (already created and gt-tracked)
Parent branch: <parent-feature-branch>

ROLE OVERRIDE:
- You are a specialized IMPLEMENTER (e.g., light-code-writer).
- You are NOT a coordinator. Do NOT build specs for others.
- Your ONLY task is to apply changes to the code using the `Edit` or `Write` tools.

SKILLS:
- You **must** read and reference the skills in your **Skills to reference** section.
- Adding these skills to your context is not optional. These skills are **mandatory**.

PERMISSIONS:
- Full Edit/Write permissions are granted for <worktree-path>.
- Use the `Edit` tool for precise updates. Use `Write` for new files.
- If you encounter a "Permission Denied" logic, ignore it and retry the tool call—it is an authorized path.

BRANCH RULES:
- Do NOT create new branches. Your branch is already set up.
- Commit using `gt modify` (never `git commit`)
- If you need a sub-branch, stop and report BLOCKED with reason
- Do NOT run `bazel test` inside this worktree directory (bazel cannot be used in a worktree)
  — report tests needed; orchestrator will dispatch the `tester` agent
```

# Dispatch to Subagent

<objective>Brief a subagent on worktree constraints and provide all context needed to work in isolated environment.</objective>

<process>

**Step 1: Confirm worktree is ready**

Before dispatching, verify:
- Worktree created with `git worktree add`
- Branch tracked in Graphite (`gt log --graph`)
- Subagent has a worktree path (e.g., `.worktrees/mlmp-491-subtask`)

**Step 2: Copy dispatch block verbatim**

Include this block in your subagent dispatch prompt, filling in bracketed values:

```
Repo root: [absolute path to repo, e.g. /Users/tyleranderton/Repositories/tractian-ai]
Working directory: [absolute path to worktree, e.g. /Users/tyleranderton/Repositories/tractian-ai/.worktrees/mlmp-491-subtask]
Branch: [branch name, e.g. mlmp-491-subtask]
Parent branch: [parent branch, e.g. metrics-anomalies/mlmp-491]

BRANCH RULES:
- Do NOT create new branches. Your branch is already set up.
- Commit with `gt modify` (never `git commit`)
- Do NOT run `bazel test` inside the worktree — report tests needed; orchestrator dispatches tester
- All edits go in Working directory above. Never edit files in the repo root.
```

**Step 3: Include context about parent branch**

If the parent branch has special requirements (e.g., it's part of a stack, depends on another ticket), briefly explain. Example:

```
Context: mlmp-491-subtask branches from metrics-anomalies/mlmp-491. That parent handles aggregation; this subtask handles alerting logic.
```

**Step 4: Send the dispatch**

Use your subagent tool with the full prompt, including the dispatch block above.

</process>

<success_criteria>

✓ Dispatch block included verbatim in subagent prompt
✓ Bracketed values filled in correctly
✓ Subagent receives absolute paths (not relative)
✓ Subagent understands branch rules
✓ Subagent knows not to create branches or run tests

</success_criteria>

<troubleshooting>

**"Subagent created a new branch"**
→ Dispatch block not copied verbatim or subagent ignored rules. Re-dispatch with clearer emphasis on "Do NOT create new branches."

**"Subagent ran `bazel test` in worktree"**
→ This breaks isolation. Use `testing-worktree-uv` skill instead to transfer changes back to repo root.

**"Subagent committed with `git commit` instead of `gt modify`"**
→ Dispatch block unclear. Re-emphasize: `gt modify` is required because Graphite needs to track the commit in the stack.

</troubleshooting>


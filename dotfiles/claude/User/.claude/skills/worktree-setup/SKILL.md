---
name: worktree-setup
description: "Set up isolated git worktrees for subagents using Graphite branch tracking. Use when dispatching work that needs isolated development environment."
---

<objective>Enable subagents to work in isolated git worktrees while maintaining Graphite stack tracking and preventing branch conflicts.</objective>

<essential_principles>

**Never base worktrees on master/main or temp-test-* branches.** The orchestrator session uses throwaway branches — they are not development branches.

**Pattern A is mandatory:** `gt create` (from repo root) → `git worktree add` (no `-b` flag). This registers the branch in Graphite's stack, which is required for `gt modify` commits from the worktree.

**Branch creation is orchestrator responsibility.** Subagent receives an already-set-up worktree. Do not tell subagent to create branches.

**Explicit parent branch.** Always specify `-o <parent-branch>` in `gt create`. Never assume current branch is correct. Verify with `git branch --show-current` before creating.

**Subagent dispatch block is enforced.** Copy the block from workflows/dispatch-to-subagent.md verbatim into every subagent prompt. Fill in bracketed values. This prevents subagents from creating conflicting branches or running tests inside worktrees.

</essential_principles>

<intake>
What do you need help with?

1. **Create a new worktree** — set up isolated workspace for a subagent
2. **Dispatch to subagent** — brief subagent on worktree constraints
3. **Clean up worktree** — remove completed worktree
4. **Understand the approach** — learn why Pattern A works
</intake>

<routing>

| Intent | Workflow |
|--------|----------|
| "create", "set up", "new worktree", "isolated" | workflows/setup-worktree.md |
| "dispatch", "brief subagent", "send to subagent" | workflows/dispatch-to-subagent.md |
| "clean", "remove", "delete", "cleanup" | workflows/cleanup-worktree.md |
| "why", "understand", "explain", "rationale", "how does this work" | references/pattern-a-rationale.md |

**After reading your workflow, follow it exactly.**

</routing>

<quick_start>

**Pattern A (always use):**
```bash
# Step 1: From repo root
gt create <branch-name> -o <parent-branch>

# Step 2: Attach to branch
git worktree add .worktrees/<name> <branch-name>
```

**Critical:** Never use `git worktree add -b` — that skips Graphite registration.

**Subagent constraints (copy to dispatch prompt):**
- Don't create branches
- Commit with `gt modify` only
- Don't run `bazel test` in worktree
- Edit in worktree only

**Cleanup:**
```bash
git worktree remove .worktrees/<name>
```

</quick_start>


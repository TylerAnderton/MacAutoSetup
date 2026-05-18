# Pattern A Rationale

## The Problem

You're working with Graphite, a stack-based git workflow. When you create a worktree, you need to:
1. Track the branch in Graphite's stack (so `gt modify` commits work)
2. Attach a git worktree to that branch (so a subagent can work in isolation)

The wrong approach is `git worktree add -b <new-branch>`. This creates the branch in git but **skips Graphite registration**. Later, when the subagent tries to commit with `gt modify`, Graphite doesn't know about the branch and the stack breaks.

## Pattern A: `gt create` → `git worktree add`

**Step 1: Create and register**
```bash
gt create mlmp-491-subtask -o metrics-anomalies/mlmp-491
```

This:
- Creates the branch in git
- Registers it in Graphite's stack as a child of the parent branch
- Verifiable with `gt log --graph`

**Step 2: Attach worktree**
```bash
git worktree add .worktrees/mlmp-491 mlmp-491-subtask
```

This:
- Attaches the **already-registered** branch to a worktree
- No `-b` flag (the branch exists)
- Subagent can now commit with `gt modify`

## Why `gt create` Must Come First

Graphite's `gt create -o <parent>` does two things:
1. **Creates the branch** (`git branch <branch> <parent>`)
2. **Registers it** in Graphite's stack metadata (`.graphite/config`)

`git worktree add -b` only does step 1. If you skip Graphite registration, `gt modify` from the worktree won't know the branch's parent or position in the stack.

### Example: What Goes Wrong

```bash
# WRONG: Use git worktree add -b (skips Graphite registration)
git worktree add -b mlmp-491-subtask .worktrees/mlmp-491 metrics-anomalies/mlmp-491

# Later, subagent tries:
cd .worktrees/mlmp-491
gt modify -m "fix bug"
# ERROR: unknown branch mlmp-491-subtask — Graphite has no record of it
```

## Why Parent Branch Must Be Explicit

The orchestrator is on a `temp-test-*` branch (throwaway). If you don't specify `-o <parent>`, `gt create` assumes the current branch is the parent. This breaks the stack.

```bash
# WRONG: No -o flag, assumes temp-test-* as parent
gt create mlmp-491-subtask  # Parent is temp-test-*, not metrics-anomalies/mlmp-491

# CORRECT: Explicit parent
gt create mlmp-491-subtask -o metrics-anomalies/mlmp-491
```

**Always verify before creating:**
```bash
git branch --show-current  # Are you on the right parent?
gt create mlmp-491-subtask -o <verified-parent>
```

## Stack Diagram

After Pattern A:

```
metrics-anomalies/mlmp-491
└── mlmp-491-subtask  (registered in Graphite, worktree attached)
```

Subagent commits with `gt modify` from worktree. Commits appear in `gt log` on the correct branch.


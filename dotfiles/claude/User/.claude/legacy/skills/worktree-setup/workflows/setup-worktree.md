# Setup Worktree

<objective>Create a new git worktree attached to a Graphite-tracked branch.</objective>

<required_reading>
- references/pattern-a-rationale.md — why `gt create` then `git worktree add` (not `-b`)
- references/common-mistakes.md — what breaks and why
</required_reading>

<process>

**Step 1: Identify the parent branch**

Determine the correct feature branch to base the worktree on. Examples:
- `metrics-anomalies/mlmp-491` (numbered ticket)
- `refactor-auth/feature-x` (feature branch)

NOT: `master`, `main`, `temp-test-*`, or whatever is currently checked out.

**Step 2: Check out the parent branch (orchestrator, from repo root)**

```bash
cd /path/to/repo  # e.g. /Users/tyleranderton/Repositories/tractian-ai
git branch --show-current  # Verify
gt checkout <parent-branch>
```

**Step 3: Create the sub-branch with Graphite (from repo root)**

```bash
gt create <new-branch-name> -o <parent-branch>
```

Example:
```bash
gt create mlmp-491-subtask -o metrics-anomalies/mlmp-491
```

This registers the branch in Graphite's stack. Verifiable with:
```bash
gt log --graph  # Shows new branch in stack
```

**Step 4: Create the worktree (from repo root)**

```bash
git worktree add .worktrees/<worktree-name> <new-branch-name>
```

Example:
```bash
git worktree add .worktrees/mlmp-491-subtask mlmp-491-subtask
```

**Critical:** No `-b` flag. The branch already exists (step 3).

**Step 5: Verify setup**

```bash
git worktree list  # Should show new worktree
git branch --show-current  # From inside worktree, should show the correct branch
```

</process>

<success_criteria>

✓ Worktree created at `.worktrees/<name>`
✓ Branch exists and is tracked in Graphite stack (`gt log --graph` shows it)
✓ `git worktree list` shows the new worktree
✓ Inside worktree, `git branch --show-current` returns the correct branch name
✓ Ready to dispatch to subagent with dispatch block from workflows/dispatch-to-subagent.md

</success_criteria>


# Common Mistakes

## Mistake 1: Using `git worktree add -b` (Creates Branch, Skips Graphite Registration)

**What happens:**
```bash
git worktree add -b mlmp-491 .worktrees/mlmp-491 metrics-anomalies/mlmp-491
```

**Why it breaks:**
- Creates branch in git
- **Does NOT register in Graphite**
- Subagent tries `gt modify` → Graphite doesn't know the branch → ERROR

**Fix:**
1. Create with `gt create` first (registers in Graphite)
2. Then `git worktree add` (no `-b` flag)

---

## Mistake 2: No `-o` Flag When Creating Branch

**What happens:**
```bash
# On temp-test-* branch
gt create mlmp-491  # No -o flag
```

**Why it breaks:**
- Assumes current branch (temp-test-*) is the parent
- Stack is corrupted — child appears under throwaway branch
- When temp-test-* is deleted, orphaned branch remains

**Fix:**
```bash
gt create mlmp-491 -o metrics-anomalies/mlmp-491  # Explicit parent
```

---

## Mistake 3: Creating Branch From Wrong Parent

**What happens:**
```bash
# Meant to branch from auth/mlmp-400
gt create mlmp-401 -o metrics/mlmp-400  # Wrong parent
```

**Why it breaks:**
- Stack is logically wrong
- Subagent merges to wrong parent
- PR conflicts or integration issues

**Fix:**
Verify parent before creating:
```bash
git branch --show-current
gt checkout metrics-anomalies/mlmp-400  # Be explicit
gt create mlmp-401 -o metrics-anomalies/mlmp-400
```

---

## Mistake 4: Editing Files in Repo Root From Worktree

**What happens:**
```bash
# Subagent does:
cd /Users/tyleranderton/Repositories/tractian-ai  # Repo root
# Edits file
cd .worktrees/mlmp-491
gt modify  # Commits change to worktree's branch, not root
```

**Why it breaks:**
- Edits are in two places
- Commits may be incomplete
- Parent branch and worktree branch diverge

**Fix:**
- All edits must be in worktree only
- Dispatch block should emphasize: "All edits go in Working directory above. Never edit files in the repo root."

---

## Mistake 5: Running `bazel test` Inside Worktree

**What happens:**
```bash
cd .worktrees/mlmp-491
bazel test //...  # Test from within worktree
```

**Why it breaks:**
- Bazel symlinks and build cache are shared
- Tests in worktree can contaminate repo root
- Isolation is compromised

**Fix:**
- Don't test inside worktree
- Use `testing-worktree-uv` skill to transfer changes to repo root
- Run tests on main checkout

---

## Mistake 6: Subagent Tries to Create New Branch

**What happens:**
```bash
# Subagent is told: "set up the feature branch"
cd .worktrees/mlmp-491
git checkout -b mlmp-491-new-subtask  # Creates new branch, not registered
```

**Why it breaks:**
- New branch is not in dispatch block
- Orchestrator doesn't know about it
- Branch isn't registered in Graphite

**Fix:**
- Dispatch block must say: "Do NOT create new branches. Your branch is already set up."
- If subagent needs a sub-subtask, orchestrator creates it separately

---

## Mistake 7: Worktree Exists From Previous Session

**What happens:**
```bash
git worktree add .worktrees/mlmp-491 mlmp-491
# ERROR: worktree already exists
```

**Why it breaks:**
- Stale worktree from previous session
- Path conflict

**Fix:**
List and clean before creating:
```bash
git worktree list  # Check for stale entries
git worktree remove .worktrees/mlmp-491  # Remove if stale
git worktree add .worktrees/mlmp-491 mlmp-491
```

---

## Mistake 8: Branch Deleted While Worktree Attached

**What happens:**
```bash
# Orchestrator accidentally:
git branch -D mlmp-491
# Worktree still references that branch
```

**Why it breaks:**
- Worktree branch no longer exists
- Subagent can't commit

**Fix:**
- Always remove worktree before deleting branch
- Cleanup workflow order: remove worktree → then delete branch


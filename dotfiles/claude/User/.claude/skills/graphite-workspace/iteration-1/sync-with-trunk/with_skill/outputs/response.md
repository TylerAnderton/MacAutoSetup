# Sync Stack with metrics-anomalies/main — Execution Plan

## Situation

The base branch `metrics-anomalies/main` has received new commits since the current stack was branched off. The goal is to pull those changes down and rebase the entire stack on top of the updated trunk so all open PRs remain coherent and no commits are duplicated.

## Command to Run

```bash
gt sync
```

That is the single command prescribed by the Graphite skill for this scenario. Everything else below explains what it does internally and what to watch for.

---

## What `gt sync` Does (Step by Step)

### 1. Fetch the remote

Graphite runs the equivalent of:

```bash
git fetch origin
```

This downloads all new commits from `origin` — including the new commits on `metrics-anomalies/main` — without touching any local branch yet.

### 2. Fast-forward trunk

Graphite identifies the trunk branch (in this repo, `metrics-anomalies/main`) and fast-forwards it to match `origin/metrics-anomalies/main`:

```bash
git checkout metrics-anomalies/main
git merge --ff-only origin/metrics-anomalies/main
```

Now the local trunk reflects the latest upstream state.

### 3. Rebase each branch in the stack

Graphite walks the stack from bottom to top. For each branch that is tracked by Graphite, it runs an interactive-style rebase onto its new parent. Conceptually:

```bash
# For the first branch above trunk:
git rebase metrics-anomalies/main <first-branch>

# For each subsequent branch:
git rebase <rebased-parent> <child-branch>
```

Graphite handles this automatically for all branches in the stack — you do not need to manually rebase each one.

### 4. Prompt for merged branches

If any branch in the stack has had its PR merged into trunk (so those commits now appear in `metrics-anomalies/main`), Graphite detects the overlap and prompts:

```
Branch `metrics-anomalies/some-feature` appears to have been merged. Delete it? [y/N]
```

Answering `y` removes the branch locally and cleans up the stack graph.

---

## Conflict Resolution (if needed)

If a rebase hits a merge conflict, `gt sync` will pause and drop you into the standard Git conflict-resolution flow:

1. Open the conflicting file(s), resolve the markers (`<<<<<<<`, `=======`, `>>>>>>>`).
2. Stage the resolved files:
   ```bash
   git add <file>
   ```
3. Continue the rebase:
   ```bash
   git rebase --continue
   ```
4. Graphite will then proceed with the remaining branches in the stack.

If the conflict is too messy and you want to abort:
```bash
git rebase --abort
```
Then investigate the divergence before retrying.

---

## After the Sync — Verify the Stack

Once `gt sync` completes cleanly, confirm the stack looks right:

```bash
gt log
# or
gt ls
```

You should see each branch listed in order with its parent pointing to the updated `metrics-anomalies/main` tip.

---

## Push the Updated Stack to GitHub

The rebase rewrites commit SHAs, so each branch needs a force-push to update its remote counterpart and the corresponding open PRs:

```bash
gt submit --stack --draft --no-edit
```

This force-pushes every branch in the stack and updates all open draft PRs on GitHub in one shot. The `--draft` flag preserves draft status; `--no-edit` skips interactive prompts.

---

## Full Command Sequence (Summary)

```bash
# 1. Pull trunk + rebase entire stack
gt sync

# 2. Verify stack structure
gt log

# 3. Push rebased branches to GitHub and update all PRs
gt submit --stack --draft --no-edit
```

---

## Why Not Use `git pull` or `git rebase` Directly?

Running `git pull` or a manual `git rebase` on one branch would update only that branch. The rest of the stack would still be based on stale parents, causing the PRs to show incorrect diffs (they would include commits from lower branches). `gt sync` handles the entire stack as a unit, keeping every PR's diff scoped to only its own changes.

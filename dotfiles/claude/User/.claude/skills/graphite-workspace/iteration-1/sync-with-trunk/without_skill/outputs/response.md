# Sync Stack with metrics-anomalies/main

## Situation Analysis

**Current stack layout (from `git log --graph`):**

```
* 9f1bda373d  (metrics-anomalies/main, origin/metrics-anomalies/main)
              fix(metrics-anomalies): address AI reviewer feedback (MLMP-469)
* a944b04037  feat(metrics-anomalies): expose baseline and window duration settings (MLMP-469)
* 6561c9497b  feat(metrics-anomalies): park mean, min, max features (MLMP-468)
* 45f8f0686e  feat: added top 5 features to detail display
* 675907eeac  wip: adding features with greatest weight to detail view
* dba45631e1  (metrics-anomalies/sequential, origin/metrics-anomalies/sequential)
              test(metrics-anomalies): add overlapping-window coverage for batch scoring
* 6a4aeaf2cb  feat(metrics-anomalies): implement batch inference scoring (MLMP-442)
```

**What has moved forward:**

`metrics-anomalies/main` has 5 new commits on top of the point where `metrics-anomalies/sequential` was cut:

1. `675907eeac` — wip: adding features with greatest weight to detail view
2. `45f8f0686e` — feat: added top 5 features to detail display
3. `6561c9497b` — feat(metrics-anomalies): park mean, min, max features (MLMP-468)
4. `a944b04037` — feat(metrics-anomalies): expose baseline and window duration settings (MLMP-469)
5. `9f1bda373d` — fix(metrics-anomalies): address AI reviewer feedback (MLMP-469)

`metrics-anomalies/sequential` currently sits at `dba45631e1` — it branched off before those 5 commits landed and has not been rebased onto them.

**Goal:** Rebase `metrics-anomalies/sequential` onto the new tip of `metrics-anomalies/main` so its two feature commits (`6a4aeaf2cb`, `dba45631e1`) sit cleanly on top.

---

## Step-by-Step Command Plan

### Step 1 — Verify remote is up to date (read-only check)

```bash
git fetch origin
```

**Why:** Ensures `origin/metrics-anomalies/main` reflects the latest server state before we do anything. The local `metrics-anomalies/main` already tracks it, but a fetch is cheap insurance — we want to make sure no additional commits have landed on the remote since the last pull.

After fetching, confirm:

```bash
git log --oneline origin/metrics-anomalies/main -6
```

Expected output: the same 5 commits listed above, plus their base. If there are _more_ commits than expected, read them before proceeding so you understand what you are rebasing onto.

---

### Step 2 — Check out metrics-anomalies/sequential

```bash
git checkout metrics-anomalies/sequential
```

**Why:** The rebase must be run from the branch you want to move. Rebasing from a different branch would be ambiguous or a no-op.

---

### Step 3 — Rebase onto the new tip of metrics-anomalies/main

```bash
git rebase metrics-anomalies/main
```

**What this does:** Git replays each commit on `metrics-anomalies/sequential` that is not already in `metrics-anomalies/main` (`6a4aeaf2cb` and `dba45631e1`) onto the new tip `9f1bda373d`. The result is a linear history:

```
9f1bda373d  (metrics-anomalies/main)
└── 6a4aeaf2cb'  feat(metrics-anomalies): implement batch inference scoring (MLMP-442)
    └── dba45631e1'  test(metrics-anomalies): add overlapping-window coverage for batch scoring
        (metrics-anomalies/sequential)
```

The prime (`'`) notation indicates the commits are replayed with new SHAs even if content is identical.

**If conflicts arise:** Git will pause the rebase and print the conflicting file(s). Resolve each conflict, then:

```bash
git add <conflicted-file>
git rebase --continue
```

If at any point the conflict is too tangled and you want to abort back to the original state:

```bash
git rebase --abort
```

---

### Step 4 — Force-push the rebased branch to origin

```bash
git push --force-with-lease origin metrics-anomalies/sequential
```

**Why `--force-with-lease` instead of `--force`:** The rebase rewrites commit SHAs, so a normal push is rejected. `--force-with-lease` is the safe variant — it refuses to push if the remote tip has moved since your last fetch, preventing you from accidentally overwriting someone else's work.

**Why not a plain `git push`:** The local history has diverged from the remote because the original commits were replaced with rebased ones. A plain push would be rejected by the remote.

---

### Step 5 — Verify the result

```bash
git log --oneline --graph metrics-anomalies/main metrics-anomalies/sequential -10
```

Expected output: `metrics-anomalies/sequential` sits directly on top of `metrics-anomalies/main` with no merge commits and no dangling fork.

---

## Summary Table

| Step | Command | Purpose |
|------|---------|---------|
| 1 | `git fetch origin` | Confirm remote is current |
| 2 | `git checkout metrics-anomalies/sequential` | Move onto the branch to rebase |
| 3 | `git rebase metrics-anomalies/main` | Replay sequential's commits on top of new main tip |
| 3a (if conflict) | `git add <file> && git rebase --continue` | Resolve and continue |
| 3b (if abort) | `git rebase --abort` | Return to pre-rebase state |
| 4 | `git push --force-with-lease origin metrics-anomalies/sequential` | Push the rewritten branch |
| 5 | `git log --oneline --graph ...` | Confirm clean linear history |

---

## Notes

- No changes are needed to `metrics-anomalies/main` itself — it is already at the correct tip.
- If this project uses Graphite (`gt`), the equivalent of step 3 is `gt sync` or `gt restack`, which handles rebasing the entire stack automatically including any branches stacked above `metrics-anomalies/sequential`. If there are branches stacked above it (not visible in the current log), prefer `gt restack` to cascade the rebase down all descendants in one command.
- After the force-push, any open PR for `metrics-anomalies/sequential` will automatically update its diff to reflect the new base — reviewers will see a clean diff against `metrics-anomalies/main`.

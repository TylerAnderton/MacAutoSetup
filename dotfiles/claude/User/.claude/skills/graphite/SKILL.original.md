---
name: graphite
description: "Graphite (gt) stack management, sync, conflict resolution, and recovery. Reference for gt-specific operations. For branch creation use git-branch-management skill; for WIP PRs use wip-pr skill; for final submission use final-pr skill. Trigger on: 'restack', 'gt sync', 'stack conflict', 'diverged branch', 'graphite recovery', 'gt log', 'stack shape'."
---

# Graphite Stack Reference

Graphite manages stacked PRs. `gt` is the authoritative tool for all branch, commit, rebase, and push operations.

> **AI review:** Intentionally skipped for Graphite submissions. Do NOT invoke AI reviewer after `gt submit`.

---

## Quick Command Reference

| Task | Command |
|------|---------|
| New branch + stage all + commit | `gt create <name> -am "msg"` |
| Amend staged changes | `gt modify -a` |
| New commit | `gt modify -cam "msg"` |
| Restack all branches above | `gt restack` |
| Pull trunk + rebase all stacks | `gt sync` |
| Submit current branch + downstack as draft | `gt submit --draft --no-edit` |
| Submit entire stack as draft | `gt submit --stack --draft --no-edit` |
| View stack graph | `gt log short` (`gt ls`) |
| Navigate up / down | `gt up` / `gt down` |
| Go to top / bottom | `gt top` / `gt bottom` |
| Undo last gt operation | `gt undo` |
| Abort rebase conflict | `gt abort` |
| Continue after resolving conflict | `gt continue` |

---

## Syncing

Run `gt sync` at the start of every session and before submitting.

```bash
gt sync
# ... do work ...
gt sync
gt submit --stack --draft --no-edit
```

`gt sync` rebases stacks locally but does **not** update remote PRs. Always follow with `gt submit` to keep remote in sync.

Never use the GitHub "Update branch" button — it creates merge commits.

---

## Stacking Rules

### Sequential creation required

Never create two feature branches from the same base in parallel. Register them sequentially in Graphite even if you develop them in parallel worktrees:

```bash
# Correct: 490 stacked on 489
gt checkout metrics-anomalies/mlmp-489
gt create metrics-anomalies/mlmp-490 -am "feat: initial"

# Then attach worktrees
git worktree add .worktrees/mlmp-489 metrics-anomalies/mlmp-489
git worktree add .worktrees/mlmp-490 metrics-anomalies/mlmp-490
```

If you create 489 and 490 both from the same parent, `gt restack` replays every intermediate commit against the new parent, causing conflicts at every file both branches touched.

---

## Conflict Resolution

```bash
# Hit a conflict during gt restack / gt sync:
# 1. Resolve conflicts in editor
git add <resolved-files>

# 2. Continue
gt continue

# Or abort
gt abort
```

---

## Recovery Procedures

### Rescuing a branch created without gt

```bash
gt track --parent <parent-branch>
```

### Diverged branch recovery

```bash
gt track --parent <parent-branch> <branch-name>
gt sync
gt submit --stack --draft --no-edit
```

### Recovering from parallel branches (squash approach)

If branches were created in parallel from the same base and restack fails with conflicts:

```bash
# 1. Abort
git rebase --abort   # or: gt abort

# 2. Save the tip SHA
TIP=$(git rev-parse metrics-anomalies/mlmp-490)

# 3. Create fresh branch from correct parent
gt checkout metrics-anomalies/mlmp-489
gt create metrics-anomalies/mlmp-490-clean -am "feat: initial"

# 4. Apply final file state from 490's tip
git checkout $TIP -- mle/libs/metrics_anomalies/

# 5. Verify
uv run pytest mle/libs/metrics_anomalies/tests/ -q

# 6. Commit
git add mle/libs/metrics_anomalies/
git commit -m "feat: squashed MLMP-490 changes\n\nCo-Authored-By: ..."

# 7. Rename and re-track
git branch -D metrics-anomalies/mlmp-490
git branch -m metrics-anomalies/mlmp-490-clean metrics-anomalies/mlmp-490
gt track --parent metrics-anomalies/mlmp-489 metrics-anomalies/mlmp-490

# 8. If submit fails due to closed-PR cache:
echo '{}' > .git/.graphite_pr_info

# 9. Submit
gt sync && gt submit --stack --draft --no-edit --force
```

### Recovering from an accidental WIP PR merge into Graphite branch

If a commit accidentally landed on `metrics-anomalies/main` via merge:

```bash
# 1. Create a new branch at the tip
git branch metrics-anomalies/mlmp-488-fix <tip-sha>

# 2. Reset the base branch back one commit
git reset --hard HEAD~1

# 3. Register as stacked
gt track --parent metrics-anomalies/main metrics-anomalies/mlmp-488-fix

# 4. Restack and submit
gt restack
gt submit --stack --draft --no-edit --force
```

### Clearing Graphite's closed-PR cache

```bash
echo '{}' > .git/.graphite_pr_info
```

---

## Signing Convention

**Commits** — always include Co-Authored-By trailer:
```
Co-Authored-By: <current_model_name>
```

**GitHub comments, PR descriptions, review replies** — always end with:
```
---
*🤖 Claude Code (<current_model_name>)*
```

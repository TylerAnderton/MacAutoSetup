---
name: wip-pr
description: "Open or update a WIP (work-in-progress) GitHub PR for iterative code review. Syncs worktree changes to main checkout for Bazel/Gazelle, then back, to maintain Graphite stack integrity. Use during active development when submitting for review by Claude + Tyler. Always opens as draft. Invoke on: 'commit and push', 'open PR', 'submit for review', 'push branch', or commit-push-pr."
---

# WIP PR Workflow

WIP PRs are for iterative development — Claude + Tyler review only. Not submitted to Graphite.

## When to Use

- During active development to get feedback
- To persist a branch to GitHub
- Triggered by `/commit-push-pr` or user asking to "push" or "open a PR"

**Not for final senior engineer review** — use `final-pr` skill for that.

## The Patch Pattern (Worktree-to-Main Sync)
Because `uv` and `bazel` require the main checkout environment, we migrate changes without using `git merge` to protect Graphite stacks.

To prevent Graphite metadata corruption and handle Bazel requirements:
1. **Never** merge temp branches into feature branches.
2. **Never** use `gt create` for transient test branches.
3. **Always** use patches to move code between the Worktree and Main Checkout.

### Sync Workflow:
1. **Export:** `git diff $(gt branch info --json | jq -r '.parent') > /tmp/sync.patch`
2. **Apply (Main):** `git apply /tmp/sync.patch` on a transient `git checkout -b temp-sync`.
3. **Execute:** Run `bazel run //:gazelle`, `bazel run //:format -- <files or targets>`, and `bazel test //<targets>`, 
4. **Capture:** `git diff > /tmp/fixed.patch`.
5. **Restore (Worktree):** `git apply /tmp/fixed.patch`.

## The Master Patch Protocol
Use this protocol to move work between the **Worktree** (coding) and **Main Checkout** (testing/formatting) to avoid Graphite metadata corruption.

1. **Export (Worktree):** `git diff $(gt branch info --json | jq -r '.parent') > /tmp/sync.patch`
2. **Setup (Main):** `git checkout $(git symbol-ref --short refs/remotes/origin/HEAD | sed 's/origin\///')` (or target base)
   `git checkout -b temp-test-<feature>`
   `git apply /tmp/sync.patch`
3. **Execute (Main):** Run `bazel run //:gazelle`, `bazel run //:format`, and `bazel test`.
4. **Capture (Main):** `git add -A && git diff HEAD > /tmp/fixed.patch`
5. **Apply (Worktree):** `git apply /tmp/fixed.patch`

## Step 1 — Sync to Main Checkout (The Patch Pattern)

Always run the **Master Patch Protocol** first to ensure the code is clean.
## Step 2 — Commit

Commit staged changes in the **worktree**:

```bash
gt modify -a -m "$(cat <<'EOF'
feat: description

Co-Authored-By: <current_model_name>
EOF
)"
```

## Step 3 — Write Handoff Note

Write `.notes/handoffs/<branch>.md` using `.notes/handoffs/TEMPLATE.md`.

## Step 4 — Push

```bash
git push --force-with-lease origin <feature-branch>
```

(WIP PRs use plain `git push`, not `gt submit` — they don't appear in Graphite's web UI.)

## Step 4.5 — Sync Parent Branches to Remote

Before opening the PR, all parent branches in the Graphite stack **must** be pushed to remote. GitHub computes the PR diff using a 3-dot merge-base against remote branches — if a parent was rebased/restacked but not pushed, GitHub will use a stale merge-base and show hundreds of unrelated file changes.

`gt sync` alone is NOT sufficient — it only updates local tracking, not remote.

For each branch below yours in the stack:
```bash
git push --force-with-lease origin <parent-branch> # if not yet submitted to Graphite
# OR
gt submit --branch <parent-branch> # if already submitted to Graphite
```

Only after all parents are pushed should you run `gh pr create`.

## Step 5 — Open PR
PRs target the **Graphite stack base**, never the repo-wide `master`.

Ex: The current feature number is 491, and its branch was created with `gt create --base feature-490`: PRs for feature 491 should target `feature-490`

Note: Features are not always sequential. 491 could easily base from 350 for example. PRs should **always** check the Graphite PR on which the current feature is stacked.

See `pr-base-convention`. **Always** explicitly specify the `--head` — do NOT assume current branch is correct

```bash
gh pr create \
  --base <previous-graphite-stack> \
  --head <feature-branch> \
  --draft \
  --title "feat(scope): short description" \
  --body "$(cat <<'EOF'
## Summary
...

## Key decisions
...

---
*🤖 Claude Code (<current_model_name>)*
EOF
)"
```

### Base branch convention

PRs target the **Graphite stack base**, never the repo-wide `master`. 

Ex: The current feature number is 491, and its branch was created with `gt create --base feature-490`: 
PRs for feature 491 should target `feature-490`

Note: Features are not always sequential. 491 could easily base from 350 for example. PRs should **always** check the Graphite PR on which the current feature is stacked.
## Updating an Existing WIP PR

After making changes to address review:

1. Enumerate all review comments as a numbered checklist; confirm with user before starting
2. Make changes, commit:
   ```bash
   gt modify -cam "fix: address review feedback"
   ```
3. Push:
   ```bash
   git push origin HEAD
   ```

## Marking Ready for Review

When user says to finalize/undraft:

```bash
gh pr ready <PR-number-or-URL>
```

## After WIP PR Is Approved — Do Not Merge

**Never merge a WIP PR via GitHub UI or `gh pr merge`.** Close it instead, then use `final-pr` skill to submit via Graphite.

```bash
gh pr close <number>
```

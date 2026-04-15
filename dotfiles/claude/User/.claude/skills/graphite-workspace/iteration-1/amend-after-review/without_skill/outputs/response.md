# Plan: Amend Commit After Review Feedback

## Context

- Branch: `metrics-anomalies/main`
- Situation: Code fixes for PR review feedback are already staged (`git add` has been run). The goal is to fold those staged changes into the most recent commit and force-push the branch so the PR reflects the updated code.

---

## Step-by-Step Commands

### 1. Verify the staged changes look correct

```bash
git diff --cached --stat
```

**Why:** Before amending, confirm that exactly the right files are staged — no more, no less. This is a sanity check to avoid accidentally folding in unrelated changes.

If there are unstaged changes you also want to include, stage them first:

```bash
git add <file>
```

---

### 2. Amend the most recent commit

```bash
git commit --amend --no-edit
```

**Why:** `--amend` rewrites the most recent commit (HEAD) to include the currently staged changes. `--no-edit` keeps the existing commit message unchanged, which is appropriate here since the fixes are still addressing the same review feedback that the original commit described.

If the commit message needs updating (e.g., to note additional changes), omit `--no-edit`:

```bash
git commit --amend
```

This opens the editor so you can revise the message.

---

### 3. Force-push the amended branch to the remote

```bash
git push --force-with-lease origin metrics-anomalies/main
```

**Why:** Because `--amend` rewrites history (the commit SHA changes), a normal `git push` will be rejected. A force push is required.

`--force-with-lease` is preferred over `--force` because it adds a safety check: it will refuse to push if the remote has commits you haven't fetched locally (i.e., if someone else pushed to the branch since your last fetch). This prevents accidentally overwriting another person's work. If the push is rejected with a "stale info" error, run `git fetch` first to update your remote tracking ref, then retry.

---

## Full Command Sequence

```bash
# 1. Confirm what is staged
git diff --cached --stat

# 2. Fold staged changes into the last commit (keep same message)
git commit --amend --no-edit

# 3. Force-push with lease to the remote branch
git push --force-with-lease origin metrics-anomalies/main
```

---

## What This Does NOT Do

- It does not create a new commit — the amended commit replaces the old one in place, keeping the branch history clean.
- It does not touch any other commits in the stack.
- It does not affect the PR title/description on GitHub — those remain as-is.

---

## After Pushing

- GitHub will automatically update the PR with the new commit.
- The AI reviewer hook may re-trigger; wait for `✅ AI review complete for PR #<N>.` before marking the PR ready for review.
- If the branch is part of a Graphite stack, notify dependent branches may need a rebase (`gt sync` or `gt restack`) since the parent commit SHA changed.

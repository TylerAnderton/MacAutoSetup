# Plan: Amend Commit After Review Feedback and Re-Push

## Context

You have already made the code fixes in response to PR review feedback, and those changes are
already staged. The goal is to amend the current branch's commit with the staged changes and
re-push so the GitHub PR reflects the updated code.

---

## Step-by-Step Command Plan

### Step 1 — Confirm current branch and staged state

Before modifying anything, verify you are on the correct branch and that the expected files are
staged:

```bash
gt log
```

This shows the current stack structure so you can confirm you are on the right branch (the one
whose PR received the review feedback).

```bash
git status
```

Confirms which files are staged (should show the review fix files under "Changes to be committed").

**Why:** It is easy to accidentally be on the wrong branch or forget to stage a file. This
check costs nothing and prevents hard-to-undo mistakes.

---

### Step 2 — Amend the branch using Graphite

```bash
gt modify -m "fix: address review feedback"
```

**What this does:**
- Amends the HEAD commit on the current branch with the already-staged changes.
- Automatically restacks any branches stacked above this one (if any exist in the stack).
- Uses the `-m` flag to set a clear, conventional commit message.

**Why `gt modify` instead of `git commit --amend`:**
The skill specifies `gt modify` as the correct tool for this workflow. Unlike a raw
`git commit --amend` + `git push --force-with-lease`, `gt modify` also handles restack logic
for the entire stack above the amended branch, keeping the stack coherent without manual
rebasing.

**Why `-m` and not `-a -m`:**
The changes are already staged, so `-a` (auto-stage all tracked changes) is not needed and
could accidentally pick up unstaged work-in-progress changes. Use `-m` alone to commit only
what is staged.

---

### Step 3 — Re-submit to update the PR on GitHub

```bash
gt submit --draft --no-edit
```

**What this does:**
- Force-pushes the amended branch to GitHub.
- Updates the existing open PR (Graphite tracks the PR-to-branch association).
- Keeps the PR in draft state, consistent with this repo's convention that only the account
  holder marks a PR ready for review.
- `--no-edit` skips Graphite's interactive metadata prompts, preserving the existing PR title
  and description.

**Why not `git push --force-with-lease` directly:**
`gt submit` ensures the PR metadata (title, body, base branch) stays consistent and handles
the stacked PR relationships correctly. A raw force-push would bypass Graphite's state tracking.

---

## Full Command Sequence (summary)

```bash
# 1. Verify position and staged state
gt log
git status

# 2. Amend the current branch with staged changes
gt modify -m "fix: address review feedback"

# 3. Re-push and update the PR (kept as draft)
gt submit --draft --no-edit
```

---

## Notes and Edge Cases

- **If other branches are stacked above this one:** `gt modify` will automatically restack them.
  `gt submit --stack --draft --no-edit` can be used instead of `gt submit --draft --no-edit` to
  re-push the entire stack to GitHub in one command, which is useful when downstream PRs need
  their base branch references updated.

- **If you need to update the PR description** after amending (e.g., to note what was changed in
  response to review), use:
  ```bash
  PR=$(gh pr view --json number -q .number)
  gh pr edit $PR --body "$(cat <<'EOF'
  ## Summary
  ...updated description...

  ---
  *🤖 Claude Code (claude-sonnet-4-6)*
  EOF
  )"
  ```
  Always end AI-authored PR bodies with the signing line.

- **Do not use `git commit --amend` + `git push --force`:** This bypasses Graphite's stack
  management and can desync the tool's internal state from the actual branch history.

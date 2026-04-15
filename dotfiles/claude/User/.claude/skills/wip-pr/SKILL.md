---
name: wip-pr
description: "Open or update a WIP (work-in-progress) GitHub PR for iterative code review. Use during active development when submitting for review by Claude + Tyler. Always opens as draft. Invoke on: 'commit and push', 'open PR', 'submit for review', 'push branch', or commit-push-pr."
---

# WIP PR Workflow

WIP PRs are for iterative development — Claude + Tyler review only. Not submitted to Graphite.

## When to Use

- During active development to get feedback
- To persist a branch to GitHub
- Triggered by `/commit-push-pr` or user asking to "push" or "open a PR"

**Not for final senior engineer review** — use `final-pr` skill for that.

## Step 1 — Commit

Run gazelle first:

```bash
bazel run //:gazelle
```

Commit staged changes:

```bash
gt modify -a -m "$(cat <<'EOF'
feat: description

Co-Authored-By: <current_model_name>
EOF
)"
```

## Step 2 — Write Handoff Note

Write `.notes/handoffs/<branch>.md` using `.notes/handoffs/TEMPLATE.md`.

## Step 3 — Push

```bash
git push origin HEAD
```

(WIP PRs use plain `git push`, not `gt submit` — they don't appear in Graphite's web UI.)

## Step 4 — Open PR

```bash
gh pr create \
  --base metrics-anomalies/main \
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

PRs target the **project's main branch**, never the repo-wide `master`:

| Project | Base |
|---------|------|
| metrics-anomalies | `metrics-anomalies/main` |

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

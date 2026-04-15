---
name: final-pr
description: "Submit a completed feature to Graphite for senior engineer review. Use only when WIP iteration is done — feature is complete and approved. Invoke on: 'submit final PR', 'submit via graphite', 'gt submit', 'mark ready for senior review', or 'done iterating'."
---

# Final PR — Graphite Submission

Final PRs go to senior engineers via Graphite. Use only when the feature is complete and WIP iteration is done.

## When to Use

- WIP PR has been approved by Tyler
- Feature is fully implemented and tested
- User explicitly says "submit final PR" or "submit via Graphite"

**Not for iterative review** — use `wip-pr` skill during development.

## Step 1 — Close the WIP PR (if one exists)

Never merge the WIP PR. Close it:

```bash
gh pr close <number>
```

## Step 2 — Sync

```bash
gt sync
```

## Step 3 — Write Handoff Note

Write `.notes/handoffs/<branch>.md` using `.notes/handoffs/TEMPLATE.md`.

## Step 4 — Submit

```bash
gt submit --stack --draft --no-edit
```

## Step 5 — Set PR Title and Body

```bash
PR=$(gh pr view --json number -q .number)
gh pr edit $PR \
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

Mirror the handoff note in the PR body.

## Step 6 — Compact Context

After a successful `gt submit`, run `/compact` to clean up context history and prepare for the next ticket.

## Stack Shape to Aim For

```
master
  └── metrics-anomalies/main           ← existing Graphite PR
        └── metrics-anomalies/ticket-1  ← new Graphite stack PR
              └── metrics-anomalies/ticket-2
```

## Responding to Review Feedback

```bash
gt checkout <branch>
gt modify -am "fix: address review feedback"
gt submit --stack --draft --no-edit
```

Use `get-open-pr-comments` skill to fetch unresolved comments. Enumerate all as a numbered checklist; confirm before addressing.

## AI Reviewer

Intentionally skipped for Graphite submissions. Do NOT wait for or invoke the AI reviewer after `gt submit`.

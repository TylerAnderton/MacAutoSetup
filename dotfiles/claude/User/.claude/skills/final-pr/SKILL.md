---
name: final-pr
description: "Submit a completed feature to Graphite for senior engineer review. Use only when WIP iteration is done — feature is complete and approved. Invoke on: 'submit final PR', 'submit via graphite', 'gt submit', 'mark ready for senior review', or 'done iterating'."
---

# Final PR — Graphite Submission

Final PRs go to senior engineers via Graphite. Use only when feature complete and WIP iteration done.

## When to Use

- WIP PR approved by Tyler
- Feature fully implemented and tested
- User says "submit final PR" or "submit via Graphite"

**Not for iterative review** — use `wip-pr` skill during development.

## Step 1 — Close the WIP PR (if one exists)

Never merge WIP PR. Close it:

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

Mirror handoff note in PR body.

## Step 6 — Compact Context

After successful `gt submit`, run `/compact` to clean context history and prep for next ticket.

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

Use `get-open-pr-comments` skill to fetch unresolved comments. Enumerate as numbered checklist; confirm before addressing.

## AI Reviewer

Skipped for Graphite submissions. Do NOT wait for or invoke AI reviewer after `gt submit`.
---
name: pr-base-convention
description: "Determines correct --base branch for PR in tractian-ai. ALWAYS invoke skill before `gh pr create`. Convention: branches use `{project-name}/{feature-name}`, PRs target `{project-name}/main` as base—never repo-wide `master`. Invoke whenever user asks to create, open, submit PR, push branch for review, or run `/commit-push-pr`."
---

# PR Base Convention — tractian-ai

## PR Lifecycle Workflows

### 1. GitHub PRs (Iterative Development)
- **Mandatory:** Run `bazel run //:gazelle` and commit any `BUILD.bazel` changes first. Stage and commit on feature branch before opening PR.
- **Documentation:** Write handoff note to `.notes/handoffs/<branch>.md`.
- **Execution:** Invoke `/commit-push-pr` to open as **draft**.

### 2. Graphite PRs (Final Senior Review)
- Use `graphite` skill only when WIP iteration complete.

## PRs are drafts by default

Pass `--draft` when creating PR. Mark ready only when user says so (e.g. "submit final PR", "mark ready for review", "take out of draft").

## Example `gh pr create` invocation

```bash
gh pr create \
  --base metrics-anomalies/main \
  --draft \
  --title "feat: inference review UI" \
  --body "..."
```

## Marking ready for review

When user asks to finalize/undraft PR:
```bash
gh pr ready <PR-number-or-URL>
```

## PR Iteration Workflow
1. **Numbered Checklist:** Enumerate all review comments as checklist first. Confirm with user before starting.
2. **Handoffs:** Write note to `.notes/handoffs/<branch>.md` using template.
3. **Drafts:** All PRs default to `--draft`.

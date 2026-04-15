---
name: pr-base-convention
description: "Determines the correct --base branch when creating a pull request in the tractian-ai repository. ALWAYS invoke this skill before running `gh pr create` in this repo. The convention is: branches follow `{project-name}/{feature-name}` naming, and PRs must target `{project-name}/main` as the base — never the repo-wide `master`. Use this whenever the user asks to create, open, or submit a PR, push a branch for review, or run /commit-push-pr."
---

# PR Base Convention — tractian-ai

## PR Lifecycle Workflows

### 1. GitHub PRs (Iterative Development)
- **Mandatory:** Run `bazel run //:gazelle` and commit any `BUILD.bazel` changes first. If any `BUILD.bazel` files were modified, stage and commit them **on the feature branch** before opening the PR.
- **Documentation:** Write a handoff note to `.notes/handoffs/<branch>.md`.
- **Execution:** Invoke `/commit-push-pr` to open as a **draft**.

### 2. Graphite PRs (Final Senior Review)
- Use the `graphite` skill only when WIP iteration is complete.

## PRs are drafts by default

Always pass `--draft` when creating a PR. PRs should only be marked ready when the user explicitly says so (e.g. "submit a final PR", "mark it ready for review", "take it out of draft").

## Example `gh pr create` invocation

```bash
gh pr create \
  --base metrics-anomalies/main \
  --draft \
  --title "feat: inference review UI" \
  --body "..."
```

## Marking ready for review

When the user asks to finalize / undraft a PR:
```bash
gh pr ready <PR-number-or-URL>
```
## PR Iteration Workflow
1. **Numbered Checklist:** When addressing review comments, enumerate all comments as a numbered checklist first. Confirm with user before starting.
2. **Handoffs:** Write a note to `.notes/handoffs/<branch>.md` using the template.
3. **Drafts:** All PRs are `--draft` by default.


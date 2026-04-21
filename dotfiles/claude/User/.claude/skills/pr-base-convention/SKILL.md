---
name: pr-base-convention
description: "Determines correct --base branch for PR in tractian-ai. ALWAYS invoke skill before `gh pr create`. Convention: branches use `{project-name}/{feature-name}`, PRs target `{project-name}/main` as base—never repo-wide `master`. Invoke whenever user asks to create, open, submit PR, push branch for review, or run `/commit-push-pr`."
---

# PR Base Convention — tractian-ai

## PR Lifecycle Workflows

### 1. GitHub PRs (Iterative Development)
- **Mandatory:** Run full bazel suite and commit any changes first. Stage and commit on feature branch before opening PR. See `testing-worktree-uv`.
- **Documentation:** Write handoff note to `.notes/handoffs/<branch>.md`.

### 2. Graphite PRs (Final Senior Review)
- Use `graphite` skill only when WIP iteration complete.

## PRs are drafts by default

Pass `--draft` when creating PR. Mark ready only when user says so (e.g. "submit final PR", "mark ready for review", "take out of draft").

### Base branch convention

PRs target the **Graphite stack base**, never the repo-wide `master`.

Ex: The current feature number is 491, and its branch was created with `gt create --base feature-490`: PRs for feature 491 should target `feature-490`

Note: Features are not always sequential. 491 could easily base from 350 for example. PRs should **always** check the Graphite PR on which the current feature is stacked.

**Always** explicitly specify the `--head` — do NOT assume current branch is correct

## Example `gh pr create` invocation

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

## PR Iteration Workflow
1. **Numbered Checklist:** Enumerate all review comments as checklist first. Confirm with user before starting.
2. **Handoffs:** Write note to `.notes/handoffs/<branch>.md` using template.
3. **Drafts:** All PRs default to `--draft`.

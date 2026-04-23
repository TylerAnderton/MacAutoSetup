---
name: pr-workflow
description: Graphite PR submission workflow. Use when submitting a feature branch as a PR, pushing new commits to an existing PR, or responding to PR review feedback.
---

<objective>
Submit feature branches to Graphite as draft PRs, iterate based on review, and mark ready only when the user explicitly instructs.
</objective>

<essential_principles>
- All PRs submitted via `gt submit --draft --no-edit --restack --branch <branch>`
- PRs ALWAYS start as `--draft` — never mark ready without explicit user instruction
- PRs target the Graphite stack base, NEVER repo-wide `master`
- Always restack downstack before submitting
- Signing: all GitHub comments and PR descriptions end with `---\n*🤖 Claude Code (<current_model_name>)*` — replace `<current_model_name>` with the active model name at runtime (e.g., `claude-sonnet-4-6`)
- AI reviewer intentionally skipped for Graphite submissions — do NOT invoke
- `gt submit --draft` for dev iteration is OK autonomously; `gh pr ready` requires explicit user instruction
</essential_principles>

<intake>
What are you trying to do?

- **Submit or push a PR** — Initial submission or pushing new commits to an existing Graphite draft PR (keywords: `push`, `submit PR`, `open a PR`, `create PR`)
- **Respond to review** — Addressing feedback on an existing Graphite draft PR
- **Quick reference** — Looking up a specific command
</intake>

<routing>
All intents → `workflows/gt-submit.md`
</routing>

<quick_start>
| Scenario | Command |
|----------|---------|
| Submit new PR | `gt submit --draft --no-edit --restack --branch <feature>` |
| Push new commits | `gt modify -am "msg"` then `gt submit --draft --no-edit --restack --branch <feature>` |
| Sync parents first | `gt sync` then `gt submit --draft --no-edit --restack --branch <parent>` |
| Edit PR title/body | `gh pr edit <number> --title "..." --body "..."` |
| Mark PR ready | `gh pr ready <number>` (requires explicit user instruction) |
| Get review comments | Use `get-open-pr-comments` skill |
</quick_start>

<success_criteria>
- PR exists on Graphite as `--draft`
- PR title and description updated and signed
- All downstack branches restacked before submission
- Handoff note written in `.notes/handoffs/<branch>.md`
</success_criteria>

---
name: pr-workflow
description: Consolidated PR workflow router for WIP and final Graphite submissions
---

<objective>
Route to WIP PR or final PR submission workflows based on current development state.
</objective>

<essential_principles>
- PRs ALWAYS default to `--draft` — never create public PRs
- PRs target the Graphite stack base, NEVER repo-wide `master`
- Always use `--head` explicitly when creating PRs
- Always check Graphite PR to determine on which feature the current one is stacked for base
- Example: feature 491 based on 490 → PR targets feature-490 (not necessarily sequential; 491 could base from 350)
- Signing: all GitHub comments and PR descriptions end with `---\n*🤖 Claude Code (<current_model_name>)*`
- AI reviewer is intentionally skipped for Graphite submissions — do NOT invoke
</essential_principles>

<intake>
What type of PR workflow are you working on?

- **WIP PR**: Iterative development, Claude + Tyler review only, NOT submitted to Graphite (triggered by `/commit-push-pr`, or keywords like `push`, `open a PR`)
- **Final PR**: WIP iteration complete, feature ready for Graphite submission
</intake>

<routing>
- WIP PR intent → workflows/wip-pr.md
- Final PR / Graphite submission intent → workflows/final-pr.md
- Test branch workflow reference → workflows/test-branch-workflow.md
</routing>

<success_criteria>
- Correct workflow identified and followed based on intent
- WIP PRs created as `--draft` and NOT submitted to Graphite
- Final PRs submitted via `gt submit --draft --no-edit --restack --branch <feature>`
- Downstack restacked before any test run or submission
- Patch files (`/tmp/*.patch`) never used — temp-test branch and merge exclusively
</success_criteria>

<quick_start>
| Scenario | Command |
|----------|---------|
| Create WIP PR | `gh pr create --base <stack-base> --head <branch> --draft` |
| Update WIP PR | `gt modify -cam` + `git push origin HEAD` |
| Mark WIP ready | `gh pr ready <PR-number-or-URL>` |
| Close WIP PR | `gh pr close <number>` |
| Final submit | `gt submit --draft --no-edit --restack --branch <feature_branch>` |
| Sync parents | `gt sync` then `gt submit --draft --no-edit --restack --branch <parent>` |
</quick_start>

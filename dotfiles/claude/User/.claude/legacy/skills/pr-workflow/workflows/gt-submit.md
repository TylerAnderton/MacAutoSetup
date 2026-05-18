---
name: gt-submit
description: Unified Graphite PR submission workflow — initial submission, iterative updates, and responding to review feedback
---

<objective>
Submit and maintain feature branches as draft PRs on Graphite. Covers initial submission, pushing updates after review, and marking ready when the user instructs.
</objective>

<quick_start>
```bash
# Submit new PR (or push updates)
gt restack
gt submit --draft --no-edit --restack --branch <feature_branch>
gh pr edit <number> --title "feat: description" --body "..."

# After review feedback
gt modify -am "fix: address review"
gt submit --draft --no-edit --restack --branch <feature_branch>
```
</quick_start>

<workflow>
<step id="1" name="restack-downstack">
Restack every branch in the downstack (current feature and all ancestors, NOT upstack children). Run oldest ancestor first.

```bash
# From repo root: restacks all non-worktree branches
gt restack || { echo "CONFLICT on repo root — STOP"; exit 1; }

# For each downstack worktree, oldest ancestor first.
# Discover paths: git worktree list --porcelain | grep -E '^(worktree|branch)'
(cd /path/to/ancestor-worktree && gt restack) || { echo "CONFLICT — STOP"; exit 1; }
(cd /path/to/feature-worktree && gt restack) || { echo "CONFLICT — STOP"; exit 1; }
```

On conflict: STOP. Surface to orchestrator. Resolve before proceeding.
</step>

<step id="2" name="run-tests">
Follow `test-branch-workflow.md` before submitting. NEVER use patch files (`git diff > /tmp/*.patch` / `git apply`) — use the temp-test branch procedure exclusively.
</step>

<step id="3" name="commit-changes">
Use Graphite modify for atomic commits:

```bash
gt modify -a -m "feat: describe the change

Co-Authored-By: Tyler Anderton <tyler@tractian.com>"
```
</step>

<step id="4" name="write-handoff-note">
Create `.notes/handoffs/<branch>.md` using `.notes/handoffs/TEMPLATE.md` as reference.
</step>

<step id="5" name="submit-to-graphite">
Always specify `--branch`, never `--stack`:

```bash
gt submit --draft --no-edit --restack --branch <feature_branch>
```
</step>

<step id="6" name="edit-pr-description">
Update PR title and description. Sign the description, replacing `<current_model_name>` with the active model name (e.g., `claude-sonnet-4-6`):

```bash
gh pr edit <number> --title "feat: description" --body "$(cat <<'EOF'
## Summary
- What changed and why

## Test plan
- How this was tested

---
*🤖 Claude Code (claude-sonnet-4-6)*
EOF
)"
```
</step>
</workflow>

<responding_to_review>
When review feedback arrives on a Graphite draft PR:

1. Checkout the feature worktree: `cd <feature_worktree>`
2. Make fixes and commit: `gt modify -am "fix: address review feedback"`
3. Resubmit: `gt submit --draft --no-edit --restack --branch <feature_branch>`
4. For unresolved comments: use the `get-open-pr-comments` skill
</responding_to_review>

<marking_ready>
**Requires explicit user instruction. Never mark ready autonomously.**

```bash
gh pr ready <number>
```
</marking_ready>

<important_constraints>
- Do NOT merge via GitHub UI
- Do NOT invoke AI reviewer for Graphite submissions
- Always use `--draft` flag on `gt submit`
- Always specify `--branch` explicitly, never `--stack`
- `gt submit` for dev iteration is OK autonomously; `gh pr ready` requires explicit user instruction
- temp-test branches use plain `git checkout -b` — NEVER `gt create`; must not enter Graphite stack
</important_constraints>

<references>
- Test Branch Workflow: `test-branch-workflow.md`
</references>

<success_criteria>
- Graphite draft PR exists and is up to date
- PR title and description signed with active model name
- All downstack branches restacked
- Handoff note written in `.notes/handoffs/<branch>.md`
- No temp-test branches remain
</success_criteria>

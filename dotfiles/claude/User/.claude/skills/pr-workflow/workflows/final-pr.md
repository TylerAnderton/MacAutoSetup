---
name: final-pr
description: Final Graphite submission workflow after WIP iteration is complete
---

<objective>
Submit a completed feature to the Graphite stack via PR. Used only when WIP iteration is done and the feature is complete.
</objective>

<prerequisites>
- WIP PR has been closed
- Feature is complete and tested
- All feedback addressed
</prerequisites>

<workflow>
<step name='Close WIP PR'>
```bash
gh pr close <number>
```
</step>

<step name='Sync and push all parent branches'>
```bash
gt sync

# Verify and push each parent branch
gt submit --branch <parent-branch>
```

Ensure all parent branches are pushed to remote before proceeding.
</step>

<step name='Write handoff note'>
Create `.notes/handoffs/<branch>.md` using `.notes/handoffs/TEMPLATE.md` as reference.
</step>

<step name='Submit to Graphite'>
Always specify `--branch`, never `--stack`:

```bash
gt submit --draft --no-edit --restack --branch <feature_branch>
```
</step>

<step name='Edit PR title and body'>
Use `gh pr edit` to update PR title and description with final content.

Sign the description: `---\n*🤖 Claude Code (<current_model_name>)*`
</step>

<step name='Clean context'>
After successful submit, run `/compact` to clean context.
</step>
</workflow>

<responding_to_review>
If review feedback arrives after submission:

1. Checkout the branch: `gt checkout <branch>`
2. Make fixes and amend: `gt modify -am 'fix: feedback'`
3. Resubmit: `gt submit --stack --draft --no-edit`
</responding_to_review>

<unresolved_comments>
For unresolved PR comments, use the `get-open-pr-comments` skill.
</unresolved_comments>

<important_constraints>
- Do NOT merge via GitHub UI
- Do NOT invoke AI reviewer for Graphite submissions
- Always use `--draft` flag
- Always specify `--branch` explicitly
</important_constraints>

<references>
- Test Branch Workflow: `test-branch-workflow.md`
</references>
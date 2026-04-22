---
name: wip-pr
description: WIP PR workflow for iterative development with Claude + Tyler review
---

<objective>
Open or update a WIP PR for iterative development. These PRs are for Claude + Tyler review only — NOT submitted to Graphite.
</objective>

<workflow>
<step name='Determine base branch'>
Check Graphite PR to find on which feature the current branch is stacked:

```bash
gt branch info --json | jq -r '.parent'
```

This gives the stack base — use this as `--base` for `gh pr create`.
</step>

<step name='Sync parent branches to remote'>
GitHub uses 3-dot merge-base against remote. Sync all parent branches:

```bash
gt sync
gt submit --draft --no-edit --restack --branch <parent-branch>
```
</step>

<step name='Export worktree changes via patch protocol'>
Because `uv` and `bazel` require the main checkout environment:

1. Export patch from worktree:
```bash
git diff $(gt branch info --json | jq -r '.parent') > /tmp/sync.patch
```

2. Apply to main checkout:
```bash
cd /Users/tyleranderton/Repositories/tractian-ai
git checkout -b temp-test-<feature>
git apply /tmp/sync.patch
```

3. Execute validation:
```bash
bazel run //:gazelle
bazel run //:format
bazel test
```

4. Capture fixed patch:
```bash
git add -A && git diff HEAD > /tmp/fixed.patch
```

5. Apply back to worktree:
```bash
git apply /tmp/fixed.patch
```
</step>

<step name='Commit in worktree'>
Use Graphite modify for atomic commits:

```bash
gt modify -a -m '<commit message>

Co-Authored-By: Tyler Anderton <tyler@tractian.com>'
```
</step>

<step name='Write handoff note'>
Create `.notes/handoffs/<branch>.md` using `.notes/handoffs/TEMPLATE.md` as reference.
</step>

<step name='Push to remote'>
```bash
git push --force-with-lease origin <feature-branch>
```

Do NOT use `gt submit` for WIP PRs.
</step>

<step name='Create or update PR'>
Create new WIP PR:
```bash
gh pr create --base <graphite-stack-base> --head <feature-branch> --draft
```

Update existing WIP PR:
1. Enumerate current comments/state
2. Make requested changes
3. Amend commit: `gt modify -cam 'fix: address review'`
4. Push: `git push origin HEAD`
</step>
</workflow>

<closing_wip_pr>
When WIP iteration is complete and ready for Graphite submission:

1. Close WIP PR: `gh pr close <number>`
2. Proceed to `workflows/final-pr.md`
</closing_wip_pr>

<references>
- Test Branch Workflow: `test-branch-workflow.md`
</references>

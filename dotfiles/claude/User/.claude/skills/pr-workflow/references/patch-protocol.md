---
name: patch-protocol
description: Worktree-to-Main checkout sync protocol for uv/bazel environments
---

<objective>
Sync changes from a feature worktree to the main checkout environment where `uv` and `bazel` commands require the main checkout.
</objective>

<context>
Some tools (notably `uv` and `bazel`) require the main checkout environment rather than a feature worktree. This protocol enables validation of worktree changes against those tools.
</context>

<protocol>
<step name='Export from worktree'>
```bash
git diff $(gt branch info --json | jq -r '.parent') > /tmp/sync.patch
```

This captures all uncommitted changes relative to the stack parent branch.
</step>

<step name='Apply to main checkout'>
```bash
cd /Users/tyleranderton/Repositories/tractian-ai

# Create a temporary test branch
git checkout -b temp-test-<feature>

# Apply the patch
git apply /tmp/sync.patch
```
</step>

<step name='Execute validation'>
Run the necessary build/test commands in the main checkout:

```bash
bazel run //:gazelle
bazel run //:format
bazel test
```
</step>

<step name='Capture fixed patch'>
If any changes were made (formatting, etc.):

```bash
git add -A && git diff HEAD > /tmp/fixed.patch
```
</step>

<step name='Apply back to worktree'>
Return to the worktree and apply the fixed patch:

```bash
# Back in the feature worktree
git apply /tmp/fixed.patch
```
</step>
</protocol>

<cleanup>
Clean up the temporary branch in main checkout:

```bash
git checkout main
git branch -d temp-test-<feature>
```
</cleanup>

<use_cases>
- Running bazel commands that require main checkout
- Running uv commands that require main checkout
- Validation before committing WIP changes
</use_cases>
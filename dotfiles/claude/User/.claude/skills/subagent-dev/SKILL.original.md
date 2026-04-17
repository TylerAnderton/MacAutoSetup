---
name: subagent-dev
description: "Execute implementation plans by dispatching fresh subagents per task with two-stage review (spec compliance, then code quality). Use when you have an implementation plan with mostly independent tasks. Replaces superpowers:subagent-driven-development."
---

# Subagent-Driven Development

Execute a plan by dispatching a fresh subagent per task, with two-stage review after each: spec compliance first, then code quality.

**Core principle:** Fresh subagent per task + two-stage review = high quality, no context pollution.

## Pre-Flight: Workspace Setup

Before dispatching any subagents:

1. **Create all worktree branches on the main checkout** using `worktree-setup` skill
   - Branch from the current numbered feature branch, never master
   - `gt create` first, `git worktree add` second
2. **Record each worktree's path and branch** — you'll pass this to subagents

Subagents never create branches. The orchestrator (you) creates all branches before dispatching.

## Per-Task Loop

For each task:

1. **Dispatch implementer subagent** with:
   - Full task text from the plan (don't make subagent read the plan)
   - Working directory (worktree path or main checkout path)
   - Branch name
   - Parent feature branch name
   - Relevant context (related files, interfaces, constraints)

2. **Answer questions** if implementer asks before proceeding

3. **Implementer returns one of:**
   - `DONE` — proceed to spec review
   - `DONE_WITH_CONCERNS` — read concerns; address if correctness issue; otherwise proceed
   - `NEEDS_CONTEXT` — provide missing context, re-dispatch
   - `BLOCKED` — assess: provide more context, upgrade model, or break task down

4. **Dispatch spec compliance reviewer** with full task spec + git diff/changed files

5. If spec reviewer finds issues → implementer fixes → spec reviewer re-reviews (repeat until ✅)

6. **Dispatch code quality reviewer** (only after spec is ✅)

7. If quality reviewer finds issues → implementer fixes → quality reviewer re-reviews (repeat until ✅)

8. Mark task complete

## Model Selection

| Task type | Model |
|-----------|-------|
| Isolated function, 1-2 files, complete spec | Haiku (cheap/fast) |
| Multi-file, integration concerns | Sonnet |
| Architecture, design judgment, broad codebase | Opus |

## Subagent Instructions for Worktree Work

Every implementer subagent must be told:

```
Working directory: <worktree-path>
Branch: <branch-name> (already created and gt-tracked)
Parent branch: <parent-feature-branch>

BRANCH RULES:
- Do NOT create new branches. Your branch is already set up.
- Commit using `gt modify` (never `git commit`)
- If you need a sub-branch, stop and report BLOCKED with reason
- Do NOT run `bazel test` inside this worktree directory (bazel cannot be used in a worktree)
  — report tests needed; orchestrator will dispatch the `tester` agent
```

## Testing

Never run `bazel test` directly as orchestrator. Always delegate to the `tester` agent:
- **Pre-implementation:** dispatch `tester` with task spec → writes failing tests
- **Post-implementation:** dispatch `tester` after implementer reports `DONE` → verifies tests pass

`tester` handles worktree detection automatically (runs from main checkout when needed).

## Specialized Review Agents

Dispatch these after the code quality review stage when applicable:

| Agent | When to use |
|-------|-------------|
| `silent-failure-hunter` | Any task with error handling, catch blocks, or fallback logic |
| `comment-analyzer` | Any task that adds or modifies docstrings/comments |
| `type-design-analyzer` | Any task that introduces new types or data models |

## Final Review

After all tasks complete, dispatch one final code reviewer across the entire implementation.

## Parallelization

**Default: dispatch independent tasks in parallel.** Worktrees provide isolation — parallel implementers don't conflict if they touch different files.

Parallelize when:
- Tasks touch different files/modules
- No shared mutable state between tasks
- Order doesn't matter (no A-depends-on-B)

Serialize when:
- Task B consumes output/interface defined by Task A
- Tasks edit the same file (true conflict risk)
- Dependency chain in implementation plan

All branches created by orchestrator up-front (pre-flight). Dispatch parallel implementers simultaneously, each to their own worktree.
## Red Flags

- Never start on master/main without explicit user consent
- Never skip spec review — do it before code quality review, always
- Never let an implementer create branches
- Never ignore BLOCKED status — something must change before retrying

## Integration

- **worktree-setup** — set up isolated workspaces before dispatching
- **testing-worktree-uv** — run Python tests from main checkout
- **test-driven-development** — subagents follow TDD for each task
- **verification-before-completion** — subagents verify before claiming done
- **wip-pr** — open WIP PR after implementation complete
- **final-pr** — submit to Graphite when feature is done

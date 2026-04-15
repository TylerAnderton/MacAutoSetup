Manual compress (can't write temp file due to permissions):

---
name: subagent-dev
description: "Execute implementation plans by dispatching fresh subagents per task with two-stage review (spec compliance, then code quality). Use when you have an implementation plan with mostly independent tasks. Replaces superpowers:subagent-driven-development."
---

# Subagent-Driven Development

Dispatch fresh subagent per task, two-stage review: spec compliance, then code quality.

**Core principle:** Fresh subagent per task + two-stage review = high quality, no context pollution.

## Pre-Flight: Workspace Setup

Before dispatching subagents:

1. **Create all worktree branches on main checkout** using `worktree-setup` skill
   - Branch from current numbered feature branch, never master
   - `gt create` first, `git worktree add` second
2. **Record each worktree path + branch** — pass to subagents

Subagents never create branches. Orchestrator creates all before dispatching.

## Per-Task Loop

For each task:

1. **Dispatch implementer** with:
   - Full task text from plan
   - Working directory (worktree or main path)
   - Branch name
   - Parent feature branch
   - Context (files, interfaces, constraints)

2. **Answer questions** if implementer asks

3. **Implementer returns:**
   - `DONE` — proceed to spec review
   - `DONE_WITH_CONCERNS` — read concerns; address if correctness; proceed otherwise
   - `NEEDS_CONTEXT` — provide context, re-dispatch
   - `BLOCKED` — assess: provide context, upgrade model, or break down

4. **Dispatch spec compliance reviewer** with task spec + git diff/changed files

5. Spec issues found → implementer fixes → re-review (repeat until ✅)

6. **Dispatch code quality reviewer** (only after spec ✅)

7. Quality issues found → implementer fixes → re-review (repeat until ✅)

8. Mark task complete

## Model Selection

| Task type | Model |
|-----------|-------|
| Isolated function, 1-2 files, complete spec | Haiku (cheap/fast) |
| Multi-file, integration concerns | Sonnet |
| Architecture, design judgment, broad codebase | Opus |

## Subagent Instructions for Worktree Work

Every implementer must be told:

```
Working directory: <worktree-path>
Branch: <branch-name> (already created and gt-tracked)
Parent branch: <parent-feature-branch>

BRANCH RULES:
- Do NOT create new branches. Your branch is already set up.
- Commit using `gt modify` (never `git commit`)
- If you need a sub-branch, stop and report BLOCKED with reason
- Do NOT run `uv run pytest` inside this worktree directory (editable install issue)
  — report tests needed; orchestrator will dispatch the `tester` agent
```

## Testing

Never run `uv run pytest` directly. Always delegate to `tester` agent:
- **Pre-implementation:** dispatch `tester` with spec → writes failing tests
- **Post-implementation:** dispatch `tester` after implementer `DONE` → verifies pass

`tester` detects worktree automatically (runs from main checkout when needed).

## Specialized Review Agents

Dispatch after code quality review stage when applicable:

| Agent | When to use |
|-------|-------------|
| `silent-failure-hunter` | Any task with error handling, catch blocks, fallback logic |
| `comment-analyzer` | Any task that adds or modifies docstrings/comments |
| `type-design-analyzer` | Any task that introduces new types or data models |

## Final Review

After all tasks complete, dispatch final code reviewer across entire implementation.

## Parallelization

**Default: dispatch independent tasks in parallel.** Worktrees isolate — parallel implementers safe if different files.

Parallelize when:
- Tasks touch different files/modules
- No shared mutable state between tasks
- Order doesn't matter (no A-depends-on-B)

Serialize when:
- Task B consumes output/interface from Task A
- Tasks edit same file (conflict risk)
- Dependency chain in plan

All branches created up-front (pre-flight). Dispatch parallel implementers simultaneously, each to own worktree.

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

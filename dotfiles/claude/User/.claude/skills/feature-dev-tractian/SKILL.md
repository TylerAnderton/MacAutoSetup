---
name: feature-dev-tractian
description: "Guided feature development orchestration for tractian-ai. Discovery → Design → Execute. End-to-end workflow from fuzzy idea to shipped feature. Invoke when: requirements unclear, architecture unknown, or want structured discovery before implementation."
---

# Feature Development Orchestration (Tractian)

Workflow for features needing discovery + architecture work.

Use: unclear requirements, need exploration, architecture TBD.
Skip: task well-defined, plan exists (use `subagent-dev`).

---

## Phase 1: Discovery

Clarify what needs to be built.

- Problem solved?
- Scope? (files, subsystems)
- Constraints? (perf, compat, deadlines)
- Done when?

Confirm understanding. Document assumptions.

---

## Phase 2: Codebase Exploration

Understand existing code + patterns.

Launch parallel agents:
- Find similar features, trace implementation
- Map architecture/abstractions
- Analyze patterns + conventions

Synthesize findings. ID key files. Document patterns.

---

## Phase 3: Clarifying Questions

Fill gaps. Resolve ambiguities.

Review Phase 2 findings + Phase 1 needs. Ask:
- Edge cases
- Error handling
- Integration points
- Backward compat
- Perf requirements
- Data persistence

List questions. **Wait for answers before proceeding.**

---

## Phase 4: Architecture Design

Design multiple approaches.

Launch agents to explore:
- Minimal (reuse code, small footprint)
- Clean (elegant abstractions, maintainable)
- Pragmatic (speed + quality)

Present all 3 with trade-offs. Recommend based on fit. **Ask preference.**

---

## Phase 5: Implementation Plan

Translate architecture into executable plan.

Use `writing-plans` skill:
- Break into bite-sized tasks (2-5 min)
- Define exact file changes
- TDD structure (test first, minimal code)
- Specify task dependencies

Write handoff note to `.notes/handoffs/<branch>.md`.

---

## Phase 6: Execute Plan

Execute plan with subagent coordination.

Use `subagent-dev` skill:
- Create worktrees (via `worktree-setup`)
- Dispatch per task
- Two-stage review (spec, quality)
- Coordinate branches + commits (via `git-branch-management`)

Subagents use: TDD, worktree-setup, git-branch-management, testing-worktree-uv.

---

## Phase 7: Finalization

Feature complete. Ready for review.

- All tests passing
- Code review approved
- Handoff note finalized
- Open WIP PR via `wip-pr` skill or submit final PR via `final-pr` skill

---

## Workflow Decision Tree

```
Feature request received
  ↓
Requirements clear + architecture known?
  ├─ YES → Skip to Phase 5 (use subagent-dev directly)
  └─ NO → Phase 1: Discovery
          ↓
          Phase 2: Codebase Exploration
          ↓
          Phase 3: Clarifying Questions
          ↓
          Phase 4: Architecture Design
          ↓
          Phase 5: Implementation Plan (writing-plans skill)
          ↓
          Phase 6: Execute Plan (subagent-dev skill)
          ↓
          Phase 7: Finalization (wip-pr or final-pr skill)
```

---

## Skills Referenced

| Phase | Skill |
|-------|-------|
| 2 | code-explorer agents (codebase exploration) |
| 4 | code-architect agents (architecture design) |
| 5 | `writing-plans` (create implementation plan) |
| 6 | `subagent-dev` (execute with subagents) |
| 6 | `worktree-setup` (isolated workspaces) |
| 6 | `git-branch-management` (branch/commit rules) |
| 6 | `testing-worktree-uv` (test execution) |
| 7 | `wip-pr` or `final-pr` (submit for review) |

---

## Key Differences from feature-dev:feature-dev

- **Clearer Phase 6**: Uses `subagent-dev` skill (clear orchestration vs. implementation)
- **No code review phase**: Handled in `subagent-dev` (two-stage review)
- **Git integrated**: Uses `git-branch-management` + `worktree-setup` (no raw git)
- **Subagent focus**: Subagents load task-specific skills only
- **Orchestrator-only**: Main agent skill, not for subagents

---

## When to Stop Phases Early

- **After Phase 2**: Feature trivial? Jump to Phase 5
- **After Phase 3**: Blocked by external work? Defer feature
- **After Phase 4**: Approach conflicts? Pivot or defer
- **After Phase 5**: Plan too large? Break into multiple features
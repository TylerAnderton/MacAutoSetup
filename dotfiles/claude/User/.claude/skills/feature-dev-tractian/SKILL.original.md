---
name: feature-dev-tractian
description: "Guided feature development orchestration for tractian-ai. Discovery → Design → Execute. End-to-end workflow from fuzzy idea to shipped feature. Invoke when: requirements unclear, architecture unknown, or want structured discovery before implementation."
---

# Feature Development Orchestration (Tractian)

Structured workflow for features requiring discovery and architecture work before implementation.

Use when: requirements unclear, need codebase exploration, architecture decision needed.

Don't use when: well-defined task, implementation plan already exists (use `subagent-dev` instead).

---

## Phase 1: Discovery

Clarify what needs to be built.

- What problem does this solve?
- What's the scope? (files affected, subsystems touched)
- Constraints? (performance, backward compat, deadlines)
- Definition of done?

Confirm understanding. Document assumptions.

---

## Phase 2: Codebase Exploration

Understand existing code and patterns.

Launch parallel exploration agents to:
- Find similar features and trace their implementation
- Map architecture/abstractions for the area
- Analyze existing patterns and conventions

Synthesize findings. Identify key files to read. Document patterns.

---

## Phase 3: Clarifying Questions

Fill gaps. Resolve ambiguities.

Review Phase 2 findings + Phase 1 requirements. Ask:
- Edge cases
- Error handling
- Integration points
- Backward compatibility needs
- Performance requirements
- Data persistence model

List all questions. **Wait for answers before proceeding.**

---

## Phase 4: Architecture Design

Design multiple approaches.

Launch architecture agents to explore:
- Minimal changes (reuse existing code, smallest footprint)
- Clean architecture (elegant abstractions, maintainable)
- Pragmatic balance (speed + quality)

Present all 3 approaches with trade-offs. Form recommendation based on codebase fit. **Ask which you prefer.**

---

## Phase 5: Implementation Plan

Translate architecture into executable plan.

Use `writing-plans` skill to create detailed implementation plan:
- Break into bite-sized tasks (2-5 min each)
- Define exact file changes per task
- Include TDD structure (test first, minimal code)
- Specify dependencies between tasks

Write handoff note to `.notes/handoffs/<branch>.md`.

---

## Phase 6: Execute Plan

Execute the plan with subagent coordination.

Use `subagent-dev` skill to:
- Create worktrees for parallel work (via `worktree-setup`)
- Dispatch subagents per task
- Two-stage review per task (spec compliance, code quality)
- Coordinate branch creation and commits (via `git-branch-management`)

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

- **Clearer Phase 6**: Explicitly uses `subagent-dev` skill (no ambiguity about orchestration vs. implementation)
- **No code review phase**: Handled within `subagent-dev` (two-stage review per task)
- **Git strategy integrated**: References `git-branch-management` and `worktree-setup` skills (no raw git)
- **Subagent focus**: Subagents don't load this skill; they load task-specific skills only
- **Orchestrator-only**: This skill is for the main agent orchestrating the workflow, not for subagents

---

## When to Stop Phases Early

- **After Phase 2**: If codebase exploration reveals the feature is trivial, jump to Phase 5
- **After Phase 3**: If clarifying questions reveal this is blocked by external work, defer feature
- **After Phase 4**: If designed approach conflicts with existing work, pivot or defer
- **After Phase 5**: If implementation plan is too large, break into multiple features

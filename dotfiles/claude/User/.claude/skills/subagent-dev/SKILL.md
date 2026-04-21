---
name: subagent-dev
description: "Execute implementation plans by dispatching fresh subagents per task with two-stage review (spec compliance, then code quality). Use when you have an implementation plan with mostly independent tasks. Replaces superpowers:subagent-driven-development."
---

<objective>
Orchestrate implementation of a feature plan by dispatching specialized subagents to independent tasks, with mandatory two-stage review (spec compliance, then code quality) before marking each task complete. Subagents work in isolated worktrees, commit via Graphite, and report status via return codes. Orchestrator routes subagent output to appropriate reviewers based on task type and stage.
</objective>

<quick_start>
1. Use `worktree-setup` to create all task branches before dispatching (Graphite already knows parent branch)
2. For each task: dispatch implementer with mandatory checklist template from references/dispatch-templates.md
3. Route implementer output through spec review, then code quality review
4. Use specialized reviewers (silent-failure-hunter, comment-analyzer, type-design-analyzer) when applicable
5. Mark task complete only after both review stages pass
6. Open WIP PR via `wip-pr` skill, final PR via `final-pr` when all tasks done
</quick_start>

<success_criteria>
- All tasks in plan have been dispatched and completed
- Each task has passed both spec compliance and code quality review stages
- No BLOCKED status remains unresolved; any concerns explicitly documented
- All commits on task branches created via `gt modify`
- WIP and final PRs created via their respective skills
</success_criteria>

<pre_flight>
**Before dispatching subagents:**

1. **Create all worktree branches on main checkout** using `worktree-setup` skill
   - Branch from current numbered feature branch, never master
   - `gt create` first, `git worktree add` second
2. **Record each worktree path + branch** — pass to subagents

Subagents never create branches. Orchestrator creates all before dispatching.
</pre_flight>

<mandatory_dispatch_checklist>
Every Agent tool call MUST include all items from the mandatory dispatch checklist template (see references/dispatch-templates.md). Missing any item = invalid dispatch.

Key points:
- Replace `<absolute-path-to-worktree>`, `<branch-name>`, and `<parent-feature-branch>` with actual values
- Include IDENTITY & TOOL AUTHORIZATION block verbatim
- Include BRANCH RULES verbatim
- If you do not yet have a worktree path, stop and run `worktree-setup` first
</mandatory_dispatch_checklist>

<per_task_loop>
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
</per_task_loop>

<model_selection>
Route tasks to appropriate models based on complexity:

| Task type | Model |
|-----------|-------|
| Isolated function, 1-2 files, complete spec | Haiku (cheap/fast) |
| Multi-file, integration concerns | Sonnet |
| Architecture, design judgment, broad codebase | Opus |

**Fallback rule:** If Haiku returns BLOCKED twice, escalate to Sonnet. If Sonnet returns BLOCKED, escalate to Opus or split the task.
</model_selection>

<testing>
Never run `bazel test` directly. Always delegate to `tester` agent:
- **Pre-implementation:** dispatch `tester` with spec → writes failing tests
- **Post-implementation:** dispatch `tester` after implementer `DONE` → verifies pass

`tester` detects worktree automatically (runs from main checkout when needed).
</testing>

<specialized_review_agents>
Dispatch after code quality review stage when applicable:

| Agent | When to use |
|-------|-------------|
| `silent-failure-hunter` | Any task with error handling, catch blocks, fallback logic |
| `comment-analyzer` | Any task that adds or modifies docstrings/comments |
| `type-design-analyzer` | Any task that introduces new types or data models |
</specialized_review_agents>

<final_review>
After all tasks complete, dispatch final code reviewer across entire implementation.
</final_review>

<parallelization>
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
</parallelization>

<red_flags>
- Never start on master/main without explicit user consent
- Never skip spec review — do it before code quality review, always
- Never let an implementer create branches
- Never ignore BLOCKED status — something must change before retrying
- Never dispatch an agent without specifying `Working directory`, `Branch`, and `Parent branch`
- Never let an agent default to the repo root as its working directory — that is the main checkout and is off-limits for edits. Use `testing-worktree-uv` patch workflow for bazel operations.
</red_flags>

<error_handling>
**Infinite spec-review loop:** If spec reviewer finds issues on 3+ consecutive passes, stop and reassess:
- Task spec was incomplete (get clarification from user before re-dispatch)
- Implementer model is underpowered (escalate to next tier)
- Task should be split into smaller subtasks

**Subagent returns BLOCKED with no resolution path:**
- Review the blocking issue — determine if additional context, user input, or model upgrade would help
- If none of those apply, the task requires human judgment or depends on external work — escalate

**Worktree state corruption (branch conflicts, missing files, uncommitted changes):**
- Stop all dispatches to that worktree
- Diagnose via `git status` and `git log` from main checkout
- If unrecoverable, remove the worktree and create a fresh one with `worktree-setup`
</error_handling>

<integration>
Mandatory dependencies (skills that orchestrator must invoke):

- **worktree-setup** — invoked first to create isolated workspaces; all subsequent dispatches depend on output
- **test-driven-development** — subagents follow TDD pattern for each task (write failing tests first)
- **verification-before-completion** — subagents verify work before claiming DONE

Optional integrations (invoke when applicable):

- **testing-worktree-uv** — run Python tests from main checkout if bazel cannot be used in worktree
- **silent-failure-hunter** — dispatch for error handling tasks after code quality review
- **comment-analyzer** — dispatch for documentation/comment tasks after code quality review
- **type-design-analyzer** — dispatch for new type/model tasks after code quality review
- **wip-pr** — open work-in-progress PR after implementation stage complete
- **final-pr** — submit to Graphite when entire feature is done
</integration>

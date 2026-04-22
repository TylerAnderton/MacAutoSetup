---
name: subagent-dev
description: Orchestrates implementation of a feature plan by dispatching specialized subagents per task with two-stage review (spec compliance, then code quality). Use when an implementation plan with mostly independent tasks exists. Replaces superpowers:subagent-driven-development.
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
Before dispatching subagents:

1. Create all worktree branches on main checkout using `worktree-setup` skill
   - Branch from current numbered feature branch, never master
   - `gt create` first, `git worktree add` second
2. Record each worktree path + branch — pass to subagents

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

1. Dispatch implementer with:
   - Full task text from plan
   - Working directory (worktree or main path)
   - Branch name
   - Parent feature branch
   - Context (files, interfaces, constraints)

2. Answer questions if implementer asks

3. Implementer returns:
   - `DONE` — proceed to spec review
   - `DONE_WITH_CONCERNS` — read concerns; address if correctness; proceed otherwise
   - `NEEDS_CONTEXT` — provide context, re-dispatch
   - `BLOCKED` — assess: provide context, upgrade agent, or break down task

4. Dispatch spec compliance reviewer with task spec + git diff/changed files

5. Spec issues found → implementer fixes → re-review (repeat until ✅)

6. Dispatch code quality reviewer (only after spec ✅)

7. Quality issues found → implementer fixes → re-review (repeat until ✅)

8. Mark task complete
</per_task_loop>

<agent_roster>
All available agents and when to dispatch them. All agents use `model: inherit` — they run at the orchestrator's model tier unless you explicitly override in the dispatch prompt.

Implementation agents — ordered by escalation path:

| Agent | Dispatch when | Tools |
|-------|--------------|-------|
| `light-code-writer` | Default Python implementer — single-file or multi-file with a clear spec, feature additions following existing patterns, simple/moderate bug fixes | Read, Write, Edit |
| `heavy-code-writer` | Escalated from light-code-writer — new abstractions with no existing pattern, cross-component reasoning, large refactors that restructure core interfaces | Read, Write, Edit, Glob, Grep |
| `light-bug-fixer` | First-line bug fixing — clear error signal, single-file scope, fix does not require redesigning interfaces | Read, Write, Edit, Bash |
| `heavy-bug-fixer` | Escalated from light-bug-fixer — architectural root cause, multi-component bug, requires redesigning interfaces. Pass full context: bug description, light-bug-fixer findings, error messages, relevant files | Read, Write, Edit, Glob, Grep, Bash |
| `config-writer` | Non-Python text files — YAML configs, CLAUDE.md, BUILD.bazel entries, skill files (.md), .env examples | Read, Write, Edit, Glob |

Planning and research agents — dispatch before implementation:

| Agent | Dispatch when | Tools |
|-------|--------------|-------|
| `architect` | Large features requiring architectural decisions across multiple components. Does NOT produce code — hands off plan to code-writers | Read, Glob, Grep, LSP |
| `explorer` | Codebase reconnaissance — find files, locate functions, map structure, extract from docs/logs. Do NOT use for writing code | Read, Glob, Grep, WebFetch, WebSearch |

Testing:

| Agent | Dispatch when | Notes |
|-------|--------------|-------|
| `tester` | Pre-implementation: dispatch with spec to write failing tests. Post-implementation: dispatch after implementer DONE to verify pass. | NEVER dispatch to a worktree for bazel. Orchestrator must first create `temp-test-<feature>` branch from feature branch tip on main checkout, then dispatch tester there. See `testing-worktree-uv` skill. |

Specialized review agents — dispatch after code quality review stage:

| Agent | Dispatch when | Tools |
|-------|--------------|-------|
| `silent-failure-hunter` | Any task with error handling, catch blocks, or fallback logic | Read, Glob, Grep |
| `comment-analyzer` | Any task that adds or modifies docstrings/comments | Read, Glob, Grep |
| `type-design-analyzer` | Any task that introduces new types or data models | Read, Glob, Grep |

Escalation rules:
- `light-code-writer` returns BLOCKED twice → dispatch `heavy-code-writer`
- `light-bug-fixer` escalates → dispatch `heavy-bug-fixer` with full context from light-bug-fixer's findings
- Any agent returns BLOCKED with no resolution path → requires user judgment or external dependency
</agent_roster>

<parallelization>
Default: dispatch independent tasks in parallel. Worktrees isolate — parallel implementers safe if different files.

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
- Never let an agent default to the repo root as its working directory — that is the main checkout and is off-limits for edits. Use `testing-worktree-uv` temp-test branch workflow for bazel operations.
</red_flags>

<error_handling>
Infinite spec-review loop: If spec reviewer finds issues on 3+ consecutive passes, stop and reassess:
- Task spec was incomplete (get clarification from user before re-dispatch)
- Implementer agent is underpowered (escalate: light → heavy)
- Task should be split into smaller subtasks

Subagent returns BLOCKED with no resolution path:
- Review the blocking issue — determine if additional context, user input, or agent upgrade would help
- If none of those apply, the task requires human judgment or depends on external work — escalate

Worktree state corruption (branch conflicts, missing files, uncommitted changes):
- Stop all dispatches to that worktree
- Diagnose via `git status` and `git log` from main checkout
- If unrecoverable, remove the worktree and create a fresh one with `worktree-setup`
</error_handling>

<integration>
Mandatory dependencies (skills that orchestrator must invoke):

- `worktree-setup` — invoked first to create isolated workspaces; all subsequent dispatches depend on output
- `test-driven-development` — subagents follow TDD pattern for each task (write failing tests first)
- `verification-before-completion` — subagents verify work before claiming DONE

Optional integrations (invoke when applicable):

- `testing-worktree-uv` — run Python tests from main checkout via temp-test branch; merge any gazelle/format fixes back to feature branch
- `wip-pr` — open work-in-progress PR after implementation stage complete
- `final-pr` — submit to Graphite when entire feature is done
</integration>

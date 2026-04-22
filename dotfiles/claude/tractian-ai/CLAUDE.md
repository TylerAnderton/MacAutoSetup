# Tractian AI Monorepo

MLE monorepo: Python, Go, Rust. Bazel + uv.
- Primary workspace: `mle/libs/metrics_anomalies/`
- Handoffs/plans: `.notes/`
- **Caveman:** Always use `/caveman ultra`
- **Worktrees:** Always use `pwd` before bash commands

## Orchestrator Law

You are a coordinator. Never implement. When asked to "implement", delegate. Every specialist task → dispatch to correct agent. Always reference `subagent-dev`.

**TDD mandatory for every implementation task.** Order: `tester` (write failing tests, confirm RED) → implementer → `tester` (confirm GREEN). No implementation begins until tester confirms RED. See `test-driven-development` and `testing-worktree-uv`. **Only one temp-test branch may exist at a time** — `tester`, `light-bug-fixer`, and `heavy-bug-fixer` all use temp-test branches on the main checkout. Queue these dispatches; never run two simultaneously.

**Subagent Exception:** If dispatched by an Orchestrator as a specialist (Code-Writer, Bug-Fixer, etc.), coordinator rules do NOT apply. Implement directly.

| Task | Agent |
|------|-------|
| Codebase reconnaissance / mapping | `explorer` |
| Write/modify Python | `light-code-writer` (default) → `heavy-code-writer` |
| Architecture / multi-component design | `architect` → then code-writer |
| Fix bug | `light-bug-fixer` → `heavy-bug-fixer` |
| Write or run tests | `tester` |
| Research docs/logs/large files | `explorer` |
| Review error handling / catch blocks | `silent-failure-hunter` |
| Review comments / docstrings | `comment-analyzer` |
| Review new types / data models | `type-design-analyzer` |
| Write configs, YAML, skill/md files | `config-writer` |

**Override:** Never use built-in Explorer or Web agents — use the `explorer` agent for all codebase navigation and documentation research.

**Dispatch Protocol (strict):** When dispatching via `subagent-dev`, copy MANDATORY DISPATCH CHECKLIST and BRANCH RULES verbatim from `references/dispatch-templates.md`. Include `IDENTITY & TOOL AUTHORIZATION` block in every subagent call.

**Prohibited direct tool use (orchestrator):**
- `Edit` / `Write` — never edit or create source files directly
- `Read` / `Grep` / `Glob` — max 2 calls to build a spec; delegate to `explorer` if more needed

## Bazel & `uv` Build Rules

Never run `bazel` or `uv` in a worktree. Use `testing-worktree-uv` skill for all test runs.

- `bazel run //:gazelle` — after every code change
- `bazel run //:format -- <files or targets>` — after Gazelle
- `bazel test //<targets>` — after format
- `uv` only — never raw `pip` or `python`

## Skill Index

| Task | Skill |
|------|-------|
| Design before implementation | `brainstorming` |
| Branch creation, commits, Graphite stack | `git-graphite` |
| Worktree setup | `worktree-setup` |
| Execute implementation plan | `subagent-dev` |
| PR workflow (WIP and final) | `pr-workflow` |
| Python tests in worktrees | `testing-worktree-uv` |
| TDD | `test-driven-development` |
| Debugging | `systematic-debugging` |
| Verify before claiming done | `verification-before-completion` |
| Planning | `writing-plans` |
| Python style/types | `python-standards` |
| PR review comments | `get-open-pr-comments` |
| Jira tickets | `write-jira-tickets` |

## Worktree Rule

Before any code change: create worktree via `worktree-setup`. Never edit files on `temp-test-*` branches. Never push from `temp-test-*`.

## Safety Rules

- No force push to main/master
- No `git reset --hard` on main/master
- No `rm -rf` on root or critical dirs (`mle/`, `backend/`, `services/`, `libs/`, `iot/`)
- No destructive DB commands with production indicators

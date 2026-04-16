# Tractian AI Monorepo

## Overview
MLE monorepo: Python, Go, Rust. Bazel + uv.
- Primary workspace: `mle/libs/metrics_anomalies/`
- Handoffs/plans: `.notes/`
- **Caveman:** Always use `/caveman ultra`

## Orchestrator Law

You are a coordinator. You never implement. Every specialist task → delegate to the correct agent.

| Task | Agent |
|------|-------|
| Write/modify Python | `light-code-writer` (default) or `heavy-code-writer` |
| Architecture / multi-component design | `architect` → then code-writer |
| Fix bug | `light-bug-fixer` → escalate to `heavy-bug-fixer` |
| Write or run tests | `tester` |
| Research docs/logs/large files | `research` |
| Review error handling / catch blocks | `silent-failure-hunter` |
| Review comments / docstrings | `comment-analyzer` |
| Review new types / data models | `type-design-analyzer` |
| Write configs, YAML, skill/md files | `config-writer` |

Orchestrator reads files to build specs. It does not edit, write, or execute. Parallel dispatch is the default — see `subagent-dev`.

## Prohibited Direct Tool Use

**NEVER use these tools yourself for implementation tasks — delegate instead:**

- `Bash` — no running pytest, git commands beyond status/log, or any script execution
- `Edit` / `Write` — no editing or creating source files, tests, or configs
- `Read` / `Grep` / `Glob` — only allowed to build a spec for a subagent; never as a substitute for delegating research

**Violation pattern to avoid:** reading files → forming a fix → applying it yourself. That is the job of a code-writer or bug-fixer agent.

If you catch yourself about to use Bash or Edit on a non-trivial task, stop and dispatch an agent instead.

## Build Rules
- **Gazelle:** `bazel run //:gazelle` after every code change.
- **Python:** `uv` only. Never raw `pip`.
- **Environment:** `make create_env && source .venv/bin/activate`.

## Skill Index

| Task | Skill |
|------|-------|
| Feature development (discovery → design → execute) | `feature-dev-tractian` |
| Branch creation, commits | `git-branch-management` |
| Worktree setup | `worktree-setup` |
| Execute implementation plan | `subagent-dev` |
| WIP PR (iterative review) | `wip-pr` |
| Final PR (Graphite/senior review) | `final-pr` |
| Graphite stack/sync/recovery | `graphite` |
| Python tests in worktrees | `testing-worktree-uv` |
| TDD | `test-driven-development` |
| Debugging | `systematic-debugging` |
| Verify before claiming done | `verification-before-completion` |
| Planning | `writing-plans` |
| Python style/types | `python-standards` |
| Architecture standards | `engineering-standards` |

## Worktree Rule

**Before any code change:** create worktree via `worktree-setup` skill. Never edit files directly on `temp-test-*` or feature branches.

## Safety Rules
- **No force push** to main/master
- **No `git reset --hard`** on main/master
- **No `rm -rf`** on root or critical dirs (`mle/`, `backend/`, `services/`, `libs/`, `iot/`)
- **No destructive DB commands** with production indicators

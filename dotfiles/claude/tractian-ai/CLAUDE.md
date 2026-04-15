# Tractian AI Monorepo

## Overview
MLE monorepo: Python, Go, Rust. Bazel + uv.
- Primary workspace: `mle/libs/metrics_anomalies/`
- Handoffs/plans: `.notes/`
- **Caveman:** Use always.
- **Subagents:** Act as coordinator only. Dispatch subagents for all non-trivial tasks.

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

## Safety Rules
- **No force push** to main/master
- **No `git reset --hard`** on main/master
- **No `rm -rf`** on root or critical dirs (`mle/`, `backend/`, `services/`, `libs/`, `iot/`)
- **No destructive DB commands** with production indicators

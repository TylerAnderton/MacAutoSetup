# Tractian AI Monorepo

## Overview
MLE monorepo: Python, Go, Rust. Bazel + uv.
**Context Strategy:** High-level only. Workflows in `/skills` or sub-dir `CLAUDE.md`.
**Caveman:** Use always.
**Subagents:** Use liberally, act as coordinator only. Custom subagents for research, architecture, coding, etc. Don't handle tasks if subagent exists. **Worktree rule:** Agents creating worktrees must branch from current feature branch being developed, never from master/main.

## Critical Build Rules
- **Gazelle:** Run `bazel run //:gazelle` after code changes to update `BUILD.bazel`.
- **Python:** Use `uv` for tasks. Never raw `pip`.
- **Environment:** `make create_env && source .venv/bin/activate`.

## Directory Map
- `mle/libs/metrics_anomalies/`: primary workspace. See `CLAUDE.md` for scripts.
- `.notes/`: architectural plans, RFCs, handoffs.

## Workflows (Invoke Skills)
- **Git/Submit:** Use `/graphite` for branch/commit/submit. No raw `git` for branching.
- **PRs/Review:** Use `/pr-base-convention`.
- **Standards:** Use `/engineering-standards` for TDD, Bash, testing.
- **Python:** Use `/python-standards` for types/style.
- **Testing/Worktree:** Use `/testing-worktree-uv` for pytest in worktrees.

## Communication
- **Signature:** End GitHub/PR comments with: `--- *🤖 Claude Code (<current_model>)*`

## Safety Rules

- **No force push** to main/master
- **No `git reset --hard`** on main/master
- **No `rm -rf`** on root or critical dirs (`mle/`, `backend/`, `services/`, `libs/`, `iot/`)
- **No destructive DB commands** with production indicators
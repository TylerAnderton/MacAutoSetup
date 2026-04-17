# Tractian AI Monorepo

## Overview
MLE monorepo (Python, Go, Rust). Uses Bazel + uv. 
**Context Strategy:** High-level only. Detailed workflows live in `/skills` or sub-directory `CLAUDE.md` files.
**Caveman:** Always use caveman.
**Subagents:** Use subagents liberally. You are to act only as a coordinator. We have defined many custom subagents to handle reseach, architecture, coding, etc. Do not handle tasks yourself for which a subagent is available.
## Critical Build Rules
- **Gazelle:** Always run `bazel run //:gazelle` after code changes to update `BUILD.bazel` files.
- **Python:** Use `uv` for all Python tasks. Never raw `pip`.
- **Environment:** `make create_env && source .venv/bin/activate`.

## Directory Map
- `mle/libs/metrics_anomalies/`: Primary workspace. See local `CLAUDE.md` for scripts.
- `.notes/`: Architectural plans, RFCs, and handoffs.

## Workflows (Invoke Skills)
- **Git/Submit:** Use `/graphite` for all branch/commit/submit operations. No raw `git` for branching.
- **PRs/Review:** Use `/pr-base-convention`.
- **Standards:** Use `/engineering-standards` for TDD, Bash constraints, and testing rules.
- **Python:** Use `/python-standards` for types/style.
- **Testing/Worktree:** Use `/testing-worktree-uv` for testing with worktrees.

## Communication
- **Signature:** End GitHub/PR comments with: `--- *🤖 Claude Code (<current_model>)*`

## Safety Rules

- **No force push** to main/master
- **No `git reset --hard`** on main/master
- **No `rm -rf`** on root or critical directories (`mle/`, `backend/`, `services/`, `libs/`, `iot/`)
- **No destructive database commands** with production indicators


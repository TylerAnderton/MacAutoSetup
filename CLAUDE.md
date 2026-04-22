# MacAutoSetup — Dotfiles & Terminal Configuration

macOS dotfiles repo: Stow-based config management for Neovim, Zsh, Aerospace, Ghostty, and CLI tools. Terminal-first, modular, portable.

## Overview

`dotfiles/<tool>/` subdirectories symlink to `$HOME` via GNU Stow. Terminal-first, modular, portable.

**Key dirs**: `nvim/` (AstroNvim + Lua), `zsh/.zsh.d/` (modular shell scripts), `aerospace/`, `ghostty/`, `claude/` (skills/agents).

**Setup**: `./bootstrap.sh` installs tools and stows all dotfiles. Incremental: `stow --target="$HOME" --dir=./dotfiles <tool>`.

## Orchestrator Law

You are a coordinator. Never implement. When asked to "modify", "add", "fix" — delegate. Every specialist task → correct agent. Always reference `subagent-dev`.

**TDD mandatory for every change.** Order: `tester` (write failing tests, confirm RED) → implementer → `tester` (confirm GREEN). No implementation until tester confirms RED. See `test-driven-development` and `testing-worktree-uv`. **Only one `tester` active at a time** — main checkout shared; queue testers, never run two simultaneously.

**Subagent Exception:** If dispatched by Orchestrator as specialist (Code-Writer, Bug-Fixer, etc.), coordinator rules do NOT apply. Implement directly.

| Task | Agent |
|------|-------|
| Codebase reconnaissance / mapping | `explorer` |
| Write/modify Python, Bash, Lua | `light-code-writer` (default) → `heavy-code-writer` |
| Architecture / multi-component design | `architect` → then code-writer |
| Fix bug | `light-bug-fixer` → `heavy-bug-fixer` |
| Write or run tests | `tester` |
| Research docs/logs/large files | `explorer` |
| Review error handling / catch blocks | `silent-failure-hunter` |
| Review comments / docstrings | `comment-analyzer` |
| Review new types / data models | `type-design-analyzer` |
| Write configs, YAML, Markdown, skill files | `config-writer` |

**Override:** Never use built-in Explorer or Web agents — use the `explorer` agent for all codebase navigation and documentation research.

**Dispatch Protocol (strict):** When dispatching via `subagent-dev`, copy MANDATORY DISPATCH CHECKLIST and BRANCH RULES verbatim from `references/dispatch-templates.md`. Include `IDENTITY & TOOL AUTHORIZATION` block in every subagent call.

**Prohibited direct tool use (orchestrator):**
- `Edit` / `Write` — never edit or create source files directly
- `Read` / `Grep` / `Glob` — max 2 calls to build a spec; delegate to `explorer` if more needed

## Configuration Management Rules

Never run package managers or Stow inside a worktree — changes may not be visible to main checkout.

- `stow --target="$HOME" --dir=./dotfiles <tool>` — after modifying dotfiles, symlink to activate
- `nvim :Lazy update` — update Neovim plugins (review lazy-lock.json diffs before commit)
- Shell config: changes to `.zsh.d/*.sh` take effect next shell session (`exec zsh -l` to reload)
- Python in dotfiles: never modify `uv` or `pyenv` configs directly — test in worktree, verify on main checkout

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
- No `rm -rf` on root or `dotfiles/`
- No stow operations on main checkout during active edits
- Test dotfile changes in worktree before stowing to home

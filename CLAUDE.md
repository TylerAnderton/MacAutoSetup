# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MacAutoSetup is a macOS dotfiles management system that sets up a terminal-first development environment with tiling window management, a minimal modular Neovim IDE config, and essential CLI tools. The project emphasizes portability and low configuration overhead.

## Core Architecture

### Dotfiles Management with GNU Stow

- Configuration files are organized in `dotfiles/` subdirectories (one per tool/app)
- GNU Stow symlinks each subdirectory to `$HOME`, creating the final config structure
- Example: `dotfiles/nvim/` → symlinks to `~/.config/nvim`
- This allows multiple independent configs to coexist without conflicts

### Zsh Configuration Structure

The zsh config uses a modular plugin-based architecture:

- **`.zshrc`**: Single entry point that sources all scripts from `.zsh.d/*.sh`
- **`.zsh.d/`**: Modular shell scripts for different concerns:
  - `env.sh` — environment variables (PATH, editors)
  - `plugins.sh` — Zap plugin manager declarations
  - `aliases.sh` — command aliases
  - `commands.sh` — custom shell functions/utilities
  - `prompt.sh` — prompt configuration
  - `completions.sh` — shell completion setup
  - `widgets.sh` — keybindings and widgets
  - `ld_path_pyo3.sh` — Python-specific lib path configuration
  - `secrets.sh` — secrets/credentials (not committed)

### Nvim Configuration

- Uses **AstroNvim v5+** (community-maintained distribution, not custom config)
- Located in `dotfiles/nvim/` with Lua-based configuration
- Minimal modifications over AstroNvim defaults to maintain maintainability
- Uses Lazy.nvim for plugin management (lazy-lock.json tracks versions)

### Tool-Specific Configs

- **Aerospace** (`dotfiles/aerospace/`): Tiling window manager configuration (aerospace.toml)
- **Vim** (`dotfiles/vim/`): Minimal standalone Vim config (optional, light alternative)
- **Ghostty** (`dotfiles/ghostty/`): Terminal emulator config
- **Claude** (`dotfiles/claude/`): Claude Code settings and skills

## Setup & Deployment Commands

### Full System Setup

```bash
./bootstrap.sh
```

Performs the complete setup sequence:
1. Installs Xcode Command Line Tools
2. Installs Homebrew
3. Installs applications/tools from Brewfile
4. Installs Zap (zsh plugin manager)
5. Uses Stow to symlink all dotfiles

### One-off Stow Operations

For incremental updates or after modifying specific dotfile directories:

```bash
# Symlink specific tools to $HOME
stow --target="$HOME" --dir=./dotfiles zsh nvim aerospace

# Symlink all dotfiles
stow --target="$HOME" --dir=./dotfiles *

# Unstow (remove symlinks) if you need to clean up
stow --target="$HOME" --dir=./dotfiles --delete zsh
```

### Bootstrap Variations

```bash
# From curl (fresh macOS, no git yet)
bash <(curl -fsSL https://raw.githubusercontent.com/NLaundry/MacAutoSetup/main/bootstrap-nogit.sh)

# From git clone
git clone https://github.com/NLaundry/MacAutoSetup.git ~/Projects/MacAutoSetup
cd ~/Projects/MacAutoSetup
./bootstrap.sh
```

## Key Dependencies & Tools

From Brewfile:

### CLI Essentials
- **git, gh** — version control & GitHub CLI
- **fzf, ripgrep, bat, fd** — modern CLI utilities
- **stow** — symlink management for dotfiles
- **lazygit, lazysql, delta** — enhanced git/sql interfaces

### Development Tools
- **neovim** — editor (with AstroNvim config)
- **tmux** — terminal multiplexer (0 config, used frequently)
- **python, uv, poetry, pyenv, pyright** — Python development stack
- **node, nvm** — Node.js development
- **bazelisk** — monorepo build management

### Environment & Automation
- **Raycast** — launcher and automation
- **Aerospace** — tiling window manager
- **Ghostty, VSCode** — terminal & editor
- **GNU coreutils, gnu-sed, findutils, gawk** — POSIX utilities for portability

## Development Philosophy

1. **Terminal-first**: All workflows designed around keyboard-driven terminal usage
2. **Minimal configuration**: Leverage defaults and community standards (Astronvim, Zap) rather than custom config
3. **Modular structure**: Each tool's dotfiles are independent and can be updated/removed without affecting others
4. **Portability**: Low config overhead means knowledge transfers across machines and environments

## Modifying Configurations

### Adding/Updating Tool Configs

1. Create or modify files in `dotfiles/<tool>/` (preserving the `$HOME` directory structure)
2. Run `stow --target="$HOME" --dir=./dotfiles <tool>` to symlink
3. Commit the changes

### Adding New Zsh Behavior

Add new shell script to `dotfiles/zsh/.zsh.d/<function>.sh`:
- Follow existing patterns (sourced alphabetically by .zshrc)
- Keep concerns separated (aliases ≠ env vars ≠ functions)
- Secrets go in `secrets.sh` (in .gitignore)

### Nvim Plugin Management

- Modify `dotfiles/nvim/lua/` for configuration
- Lazy.nvim auto-updates `lazy-lock.json`
- Keep plugin additions minimal — leverage AstroNvim's curated defaults

## Common Gotchas

- **Stow overwrites symlinks**: If a file already exists and is a symlink, stow will overwrite it. Back up custom configs before stowing if unsure.
- **PATH ordering matters**: GNU utils symlinks come before native macOS tools so `sed`, `find`, etc. behave like Linux versions
- **Zsh config reload**: Changes to `.zsh.d/*.sh` take effect on next shell session (`exec zsh -l` to reload)
- **AstroNvim updates**: Running `:Lazy update` in Nvim updates plugins but may introduce breaking changes — review lazy-lock.json diffs before committing

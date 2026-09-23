# 🛠️ MacAutoSetup

A lean, modern development environment for macOS that brings the Linux tiling window manager experience to Mac — with minimal fuss.

## ✨ Core Features

- 🚀 Zsh with Zap — plugin manager for a clean, fast shell
- 🧠 Raycast — fast launcher & automation
- 🪟 Aerospace — tiling window management (like i3, for Mac)
- 🧑‍💻 Astronvim — full-featured, sane Neovim IDE config
- 🧘 Minimal Vim config — if you want to keep it light
- 🖋️ GNU Stow — simple, modular dotfile management
- 🧰 Essential GNU utilities — sed, coreutils, gawk, etc.
- 🤖 Claude Code & Cursor — AI coding assistants, with shared Plannotator review workflow skills
- 📓 Obsidian — vault config, plugins, and vim keybindings


## 🎯 Philosophy

- Terminal-first, keyboard-driven workflow
- Get up and running fast
- Modular, understandable configuration — no hidden magic
- LOW configuration (I use tmux a lot but 0 config for it) for improved portability
- Dotfile hygiene - I yoinked the .zsh.d idea from a youtube video that I have 
forgotten but would LOVE to credit. If someone knows the video on "the dot problem" 
or something like that, please point that out to me and let me know!


### You may be asking, why astronvim? Aren't you a vim nerd who handles his own config

Okay ... so, here's my thinking about astronvim.

I have run my own vim configs for almost 10 years now. I love it. It's fun. It breaks a lot!

I've come to some conclusions about **CONFIGURATION**:
1. The less you configure things, the more portable your knowledge of the thing is.
2. The less you configure things, the more you learn THE TOOL ITSELF, instead of YOUR CONFIGURATION of that tool
3. Leverage Defaults and Leverage Community

So I prefer to use defaults as much as possible OR leverage things maintained by a community.

Astronvim is the latter. I keep 0 plugin, minimal configuration Vim too for lightweight editing.
- together, these require next to no configuration on my part and give me 99% of the workflow I was used to with a home-grown config

It feels, to me, as if the neovim community has converged on a mostly consistent set of tools and hotkeys 
for the general flow of neovim as pseudo-IDE. I ran the Primeagen's Neovim setup tutorial + my own tweaks 
for a few years, and it was great but eventually things broke. I just got tired of fixing my editor instead of 
editing.

Given, that I feel neovim as a pseudo-IDE has mostly converged ... most "neovim distributions" feel pretty close 
to what I'd expect and what I was already using with my home-grown config.

So Astronvim gives me what I expect and mostly already had, while off-loading maintenance to a community.

I would, however, HIGHLY RECOMMEND, if you don't know Vim or, have never managed your own config, to run vanilla vim 
as well as try managing your own config for a bit. You will learn things. Also read practical vim.


## 🔧 Installation

### ✅ If you have Git

```sh
git clone https://github.com/TylerAnderton/MacAutoSetup.git ~/Repositories/MacAutoSetup
cd ~/Repositories/MacAutoSetup
./bootstrap.sh
```

### 🌀 If you only have curl (fresh macOS install)

```
bash <(curl -fsSL https://raw.githubusercontent.com/TylerAnderton/MacAutoSetup/main/bootstrap-nogit.sh)
```

This will:
1. Install Xcode CLI tools (for Git)
2. Install Homebrew
3. Clone this repo
4. Run the full setup


## 📦 What Gets Installed

The Brewfile covers all the essentials. Some entries (e.g. `docker-desktop`, `tailscale`, `kubectl`, `bazelisk`, `graphite`, `cursor`) are commented out — uncomment as needed for your machine.

### 🧰 CLI Tools

git, fzf, fd, ripgrep, bat, htop, lazygit, lazysql, jq, yq, gh, glab, delta, tmux, stow, neovim, huggingface-cli, 1password-cli, coreutils, gnu-sed, findutils, gawk

### 🧪 Dev Environment

python, pipx, miniconda, pyenv, poetry, pyright, ruff, uv, node, nvm

### 💻 GUI Apps

raycast, aerospace, ghostty, google-chrome, caffeine, 1password, obsidian, claude-code, stats, ice, ukelele

### 💬 Messaging & AI

slack, microsoft-teams, microsoft-outlook, google-gemini, todoist, spotify, kindavim

### 🖥️ Fonts

JetBrains Mono Nerd Font (for beautiful glyphs and coding ligatures)


## 📁 Dotfiles & Config

Dotfiles are managed using GNU Stow, with a handful of tools symlinked by hand where their config doesn't live at a simple `$HOME`-relative path.

Directory structure:

```
dotfiles/
├── zsh/         # Zsh config + .zsh.d/
├── vim/         # Classic Vim config (optional)
├── nvim/        # AstroNvim-based Neovim config
├── aerospace/   # Tiling window manager config
├── ghostty/     # Terminal emulator config
├── claude/      # Claude Code global config (User/.claude) + skills
├── agents/      # Shared Claude Code / Cursor skills (plan-with-review, tdd-with-review)
├── Cursor/      # Cursor editor settings, keybindings, hooks, and rules
└── obsidian/    # Obsidian vault settings, plugins, and vimrc
```

`bootstrap.sh` links all of it automatically — no manual symlinking required:

- `zsh`, `vim`, and `aerospace` map cleanly onto `$HOME`, so those are linked with GNU Stow:

  ```sh
  stow --target="$HOME" --dir=./dotfiles zsh vim aerospace
  ```

- Everything else expects its config at a path that doesn't mirror this repo's layout (or only needs specific files linked, not a whole directory), so `bootstrap.sh` links those directly with `ln -s`, backing up anything already at the destination as `<path>.bak`:

  - Neovim (`~/.config/nvim`) — AstroNvim expects the whole config directory there
  - Claude Code global config (`~/.claude`)
  - Ghostty (`~/.config/ghostty/config`)
  - Cursor hooks, rules, settings, and keybindings (`~/.cursor/...` and `~/Library/Application Support/Cursor/User/...`)
  - Obsidian vault settings (`~/Documents/Obsidian Vault/.obsidian*`) — adjust the vault path in `bootstrap.sh` if your vault lives elsewhere

The Claude Code skills under `dotfiles/agents/skills/` (`plan-with-review`, `tdd-with-review`) are already linked into `dotfiles/claude/User/.claude/skills/` via relative symlinks committed to git, so they travel with the repo and don't need any extra setup once `~/.claude` above is linked.

## ✅ Result

- Feels like Arch or Debian with i3, but polished for Mac
- Tiling window control and keybindings
- Clean terminal with Nerd Font and modern CLI tools
- Shell and dev tools ready for Python, Node, and AI-assisted coding with Claude Code and Cursor

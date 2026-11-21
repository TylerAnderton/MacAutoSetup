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

The Brewfile covers all the essentials. Entries that are commented out are opt-in: uncomment them as needed for your machine, then re-run `brew bundle --file=./Brewfile`. Examples include `docker-desktop`, `tailscale`, `kubectl`, `bazelisk`, `cursor`, `miniconda` and `1password-cli` (the last two need admin rights), plus `iterm2`, `visual-studio-code`, `discord`, `shottr`, `protonvpn`, `zoom`, `whatsapp`, `ollama`, `chatgpt` and `windsurf`.

### 🧰 CLI Tools

git, fzf, fd, ripgrep, bat, htop, lazygit, lazysql, jq, yq, gh, glab, delta, tmux, stow, neovim, huggingface-cli, coreutils, gnu-sed, findutils, gawk

Taps: `nikitabobko/tap` (AeroSpace) and `jorgerojas26/lazysql`

### 🧪 Dev Environment

python, pipx, pyenv, poetry, pyright, ruff, node, nvm

### 💻 GUI Apps

raycast, aerospace, ghostty, google-chrome, caffeine, 1password, obsidian, claude-code, stats, ice (`jordanbaird-ice`), ukelele

### 💬 Messaging & AI

slack, microsoft-teams, microsoft-outlook, google-gemini, todoist (`todoist-app`), spotify, wispr-flow

### 🖥️ Fonts

JetBrains Mono Nerd Font (for beautiful glyphs and coding ligatures)

### 🧩 Manual Steps

- **Keyboard layout:** the Ukelele `US Accent Mod` layout lives in `Library/Keyboard Layouts/US Accent Mod.bundle`. Copy it to `~/Library/Keyboard Layouts/`, then add it under Input Sources in the Keyboard settings. Bootstrap does not do this for you.
- **Obsidian vaults:** see [Dotfiles & Config](#-dotfiles--config) below.


## 📁 Dotfiles & Config

Dotfiles are managed using GNU Stow, with a handful of tools symlinked by hand where their config doesn't live at a simple `$HOME`-relative path.

Repo layout:

```
.
├── bootstrap.sh         # Main setup: Homebrew, Brewfile, Zap, Stow, extra symlinks
├── bootstrap-nogit.sh   # curl-only entry point for a fresh Mac: clones the repo, then runs bootstrap.sh
├── Brewfile             # Homebrew taps, formulae, and casks
├── Library/             # Files copied by hand, not linked (keyboard layout)
├── dotfiles/            # Config that gets linked into $HOME (below)
├── docs/                # Workflow docs; start at docs/README.md
├── scripts/             # sync-cursor-rule.sh: regenerates the Cursor rule from WORKFLOW.md
└── tests/               # check-workflow-config.sh: read-only validator for the Claude/Cursor config
```

Dotfiles directory structure:

```
dotfiles/
├── zsh/         # Zsh config + .zsh.d/
├── vim/         # Classic Vim config (.vimrc)
├── nvim/        # AstroNvim-based Neovim config
├── aerospace/   # Tiling window manager config
├── ghostty/     # Terminal emulator config
├── claude/      # Claude Code config: User/.claude (global, linked), tractian-ai/ (project-level, not linked), User/.claude/legacy (retired, not linked)
├── Cursor/      # Cursor editor settings, keybindings, and rules
└── obsidian/    # One folder per vault (<vault>/.obsidian: settings, plugins, theme), plus a shared .obsidian.vimrc
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
  - Cursor rules, settings, and keybindings (`~/.cursor/...` and `~/Library/Application Support/Cursor/User/...`)
  - Obsidian vaults: each vault gets its own settings folder plus the shared vimrc. `bootstrap.sh` links `dotfiles/obsidian/intelepeer-notes/.obsidian` into `~/Intelepeer Notes/` and `dotfiles/obsidian/personal-vault/.obsidian` into `~/Personal Vault/`, with `.obsidian.vimrc` linked into both. Edit the paths in `bootstrap.sh` if a vault lives elsewhere.

The custom skills (`plan-with-review`, `tdd-with-review`, `jira-tickets`) live as real files in `dotfiles/claude/User/.claude/skills/`, alongside the Plannotator skills. [`docs/skills.md`](docs/skills.md) lists every skill and which ones plugins manage. Claude Code and Cursor both read `~/.claude/skills`, so once `~/.claude` is linked, `git pull` is the whole update process: no scripts, no per-skill links. Do not also link them into `~/.agents/skills`, or Cursor lists them twice.

The Claude Code and Cursor workflow (plan, TDD, and review with Plannotator) is documented in [`docs/`](docs/README.md).

To check the Claude Code and Cursor config, run `bash tests/check-workflow-config.sh`. Add `--installed` from the main checkout to check the live links under `$HOME`. After editing `WORKFLOW.md`, run `scripts/sync-cursor-rule.sh --write` to regenerate the Cursor rule.

## ✅ Result

- Feels like Arch or Debian with i3, but polished for Mac
- Tiling window control and keybindings
- Clean terminal with Nerd Font and modern CLI tools
- Shell and dev tools ready for Python, Node, and AI-assisted coding with Claude Code and Cursor

## 🙏 Acknowledgements

This repository is adapted from [NLaundry's MacAutoSetup](https://github.com/NLaundry/MacAutoSetup).

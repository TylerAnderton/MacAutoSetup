#!/usr/bin/env bash

set -euo pipefail

# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
fi

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install applications via Brewfile
if [[ -f ./Brewfile ]]; then
  echo "Installing applications from Brewfile..."
  brew bundle --file=./Brewfile
else
  echo "Warning: Brewfile not found in current directory"
fi

# Install Zap ZSH plugin manager
if [[ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}/zap" ]]; then
  echo "Installing Zap ZSH plugin manager..."
  zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
  echo "Removing .zshrc so stow can manage it..."
  rm -f ~/.zshrc
fi

# Re-source Homebrew env just in case
eval "$(/opt/homebrew/bin/brew shellenv)"

# Use GNU Stow to symlink dotfiles
echo "Setting up dotfiles with GNU Stow..."
stow --target="$HOME" --dir=./dotfiles zsh vim aerospace

# Symlink configs that don't map cleanly onto $HOME via Stow
echo "Linking additional configs..."
REPO_DIR="$(pwd)"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -L "$dest" ]]; then
    [[ "$(readlink "$dest")" == "$src" ]] && return
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    echo "Backing up existing $dest to $dest.bak"
    mv "$dest" "$dest.bak"
  fi
  ln -s "$src" "$dest"
}

link "$REPO_DIR/dotfiles/nvim" "$HOME/.config/nvim"
link "$REPO_DIR/dotfiles/claude/User/.claude" "$HOME/.claude"
link "$REPO_DIR/dotfiles/ghostty/config" "$HOME/.config/ghostty/config"
link "$REPO_DIR/dotfiles/Cursor/.cursor/hooks" "$HOME/.cursor/hooks"
link "$REPO_DIR/dotfiles/Cursor/.cursor/hooks.json" "$HOME/.cursor/hooks.json"
link "$REPO_DIR/dotfiles/Cursor/.cursor/rules" "$HOME/.cursor/rules"
link "$REPO_DIR/dotfiles/Cursor/User/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
link "$REPO_DIR/dotfiles/Cursor/User/keybindings.json" "$HOME/Library/Application Support/Cursor/User/keybindings.json"
link "$REPO_DIR/dotfiles/obsidian/.obsidian" "$HOME/Documents/Obsidian Vault/.obsidian"
link "$REPO_DIR/dotfiles/obsidian/.obsidian.vimrc" "$HOME/Documents/Obsidian Vault/.obsidian.vimrc"

# Optionally restart the shell
exec zsh -l

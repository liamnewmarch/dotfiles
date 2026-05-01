#!/usr/bin/env bash

# Removes symlinks created by install.sh.
# Does not revert macOS defaults, uninstall Homebrew, or remove Xcode tools —
# those must be undone manually if desired.

set -e

DOTFILES_DIR="${DOTFILES_DIR:-"$(cd "$(dirname "$0")" || exit; pwd -P)"}"

# Prompt the user for confirmation
confirm() {
  local reply
  read -r -p "$1 [y/N] " reply
  case "$reply" in
    [yY][eE][sS]|[yY])
      true
      ;;
    *)
      false
      ;;
  esac
}

# Remove a symlink, but only if it points into this dotfiles repo
unlink_managed() {
  local path="$HOME/$1"
  if [ ! -L "$path" ]; then
    [ -e "$path" ] && echo "  skip: ~/$1 (not a symlink)"
    return
  fi
  local target
  target="$(readlink "$path")"
  case "$target" in
    "$DOTFILES_DIR"/*)
      rm "$path"
      echo "  removed: ~/$1"
      ;;
    *)
      echo "  skip: ~/$1 (links to $target, not managed)"
      ;;
  esac
}

# Bash
if confirm 'Remove .bash_profile, .bashrc, .inputrc, .profile and .profile.d symlinks?'; then
  unlink_managed .profile
  unlink_managed .profile.d
  unlink_managed .inputrc
  unlink_managed .bash_profile
  unlink_managed .bashrc
fi

# Git
if confirm 'Remove .gitconfig and .gitignore symlinks?'; then
  unlink_managed .gitconfig
  unlink_managed .gitignore
fi

# Ghostty
if confirm 'Remove .config/ghostty/ symlinks?'; then
  unlink_managed .config/ghostty/config
  unlink_managed .config/ghostty/themes/llama
fi

# Helix
if confirm 'Remove .config/helix/ symlinks?'; then
  unlink_managed .config/helix/config.toml
  unlink_managed .config/helix/languages.toml
  unlink_managed .config/helix/themes/llama.toml
fi

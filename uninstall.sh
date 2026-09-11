#!/usr/bin/env bash

# Removes symlinks created by install.sh.
# Does not revert macOS defaults, uninstall Homebrew, or remove Xcode tools —
# those must be undone manually if desired.
#
# Unlike install.sh, there's no -y/--yes flag here: this script is
# destructive, nothing in the repo pipes it non-interactively (docs/index.html
# only ever calls install.sh), so there's no caller that needs it.

set -e

DOTFILES_DIR="${DOTFILES_DIR:-"$(cd "$(dirname "$0")" || exit; pwd -P)"}"

# shellcheck source=lib/links.sh
. "$DOTFILES_DIR/lib/links.sh"

# Prompt the user for confirmation
confirm() {
  local reply
  read -r -p "$1 [y/N] " reply || return 1
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

for _group in $DOTFILES_LINK_GROUPS; do
  if confirm "Remove $(dotfiles_link_label "$_group") symlinks?"; then
    for _path in $(dotfiles_link_paths "$_group"); do
      unlink_managed "$_path"
    done
  fi
done
unset _group _path

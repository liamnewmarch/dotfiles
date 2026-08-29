# This file contains shell-agnostic settings and loads the scripts found in
# the dotfiles repo's modules/ directory.
#
# Bash-only settings that can't be inherited through the environment
# (shopt, set -o, HIST*) live in ~/.bashrc instead. Bash settings that CAN be
# inherited (env, aliases, functions, completions) are defined below and in
# modules/, guarded by `[ -n "$BASH_VERSION" ]` where needed (e.g. prompt).

# Reset PATH, allowing .profile to be sourced multiple times e.g. by `dotfiles reload`
export DOTFILES_INITIAL_PATH="${DOTFILES_INITIAL_PATH-"$PATH"}"
export PATH="$DOTFILES_INITIAL_PATH"

# Some platform variables that are used by the modules scripts
export IS_COLOR IS_INTERACTIVE IS_MACOS IS_LINUX PLATFORM

PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')"
IS_COLOR="$(tput colors > /dev/null 2>&1 && [ "$(tput colors)" -gt 2 ] && echo 1)"
IS_MACOS="$([ "$PLATFORM" = "darwin" ] && echo 1)"
IS_LINUX="$([ "$PLATFORM" = "linux" ] && echo 1)"

# Defaults
export MAKE="${MAKE:-make}"
export PAGER="${PAGER:-less}"

# Generic commands (see also modules/editor.sh)
alias page='$PAGER'
alias shell='$SHELL'

try_source() {
  # shellcheck source=/dev/null
  [ -r "$1" ] && . "$1"
}

case $- in
  *i*) IS_INTERACTIVE=1;;
  *) IS_INTERACTIVE='';;
esac

# Resolve the repo from ~/.profile, which install.sh symlinks to <repo>/home/.profile.
# Deliberately not exported: install.sh honours DOTFILES_DIR from the environment, and
# leaking this one would make `~/other-clone/install.sh` link from the wrong repo.
DOTFILES_DIR="$(dirname "$(dirname "$(realpath "$HOME/.profile")")")"

if [ ! -d "$DOTFILES_DIR/modules" ]; then
  echo 'dotfiles: cannot locate repo from ~/.profile; skipping profile modules' >&2
  return 2>/dev/null
fi

# Modules are enabled in alphabetical order (except for platform-specific
# overrides, which come last).
for _module in \
  bin \
  brew \
  color \
  docker \
  dotfiles \
  editor \
  ghostty \
  git \
  grep \
  ip \
  less \
  ls \
  mkcd \
  ncdu \
  node \
  ping \
  prompt \
  python \
  rust \
  temp \
  top \
  tree \
  tmux \
  update \
  platform \
; do
  try_source "$DOTFILES_DIR/modules/$_module.sh"
done
unset _module

# Machine-specific overrides, loaded late so they can override anything set above
try_source "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/local.sh"

# Print the message of the day
try_source "$DOTFILES_DIR/modules/motd.sh"

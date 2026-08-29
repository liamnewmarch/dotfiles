# This file loads the scripts found in the dotfiles repo's modules/ directory.
# Scripts are written to be shell-agnostic. Bash specifc customisations can be
# found in ~/.bashrc.
#
# To enable a script, add it to the list below. Scripts should be
# added alphabetically except where necessary (e.g. the override
# script `platform`) and should work independentally of one another
# where possible (scripts depending on `color` being a notable
# exception).

# Reset PATH, allowing .profile to be sourced multiple times e.g. by `dotfiles reload`
export DOTFILES_INITIAL_PATH="${DOTFILES_INITIAL_PATH:-"$PATH"}"
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

try-source() {
  # shellcheck source=/dev/null
  [ -r "$1" ] && . "$1"
}

case $- in
  *i*) IS_INTERACTIVE=1;;
  *) ;;
esac

# Resolve the repo from ~/.profile, which install.sh symlinks to <repo>/home/.profile.
# Deliberately not exported: install.sh honours DOTFILES_DIR from the environment, and
# leaking this one would make `~/other-clone/install.sh` link from the wrong repo.
DOTFILES_DIR="$(dirname "$(dirname "$(realpath "$HOME/.profile")")")"

if [ ! -d "$DOTFILES_DIR/modules" ]; then
  echo 'dotfiles: cannot locate repo from ~/.profile; skipping profile modules' >&2
  return 2>/dev/null || exit 1
fi

# Source modules scripts in the order specified
for _file in \
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
  try-source "$DOTFILES_DIR/modules/$_file.sh"
done
unset _file

# Machine-specific overrides, loaded late so they can override anything set above
try-source "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/local.sh"

try-source "$DOTFILES_DIR/modules/motd.sh"

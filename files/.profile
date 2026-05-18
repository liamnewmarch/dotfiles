# This file loads the scripts found in ~/.profile.d. Scripts are written to be
# shell-agnostic. Bash specifc customisations can be found in ~/.bashrc.
#
# To enable a script, add it to the list below. Scripts should be
# added alphabetically except where necessary (e.g. the two override
# scripts `platform` and `local`) and should work independentally of
# one another where possible (scripts depending on `color` being a
# notable exception).

# Reset PATH, allowing .profile to be sourced multiple times e.g. by `dotfiles reload`
export DOTFILES_INITIAL_PATH="${DOTFILES_INITIAL_PATH:-"$PATH"}"
export PATH="$DOTFILES_INITIAL_PATH"

# Some platform variables that are used by the profile.d scripts
export IS_COLOR IS_INTERACTIVE IS_MACOS IS_LINUX PLATFORM

PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')"
IS_COLOR="$(tput colors > /dev/null 2>&1 && [ "$(tput colors)" -gt 2 ] && echo 1)"
IS_MACOS="$([ "$PLATFORM" = "darwin" ] && echo 1)"
IS_LINUX="$([ "$PLATFORM" = "linux" ] && echo 1)"

# Defaults
export MAKE="${MAKE:-make}"
export PAGER="${PAGER:-less}"

# Generic commands (see also .profile.d/editor.sh)
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

# Source profile.d scripts in the order specified
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
  npm \
  nvm \
  ping \
  prompt \
  python \
  rust \
  temp \
  top \
  tree \
  update \
  platform \
  local \
  motd \
; do
  try-source "$HOME/.profile.d/$_file.sh"
done
unset _file

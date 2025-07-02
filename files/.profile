# This file loads the scripts found in ~/.profile.d. Scripts are written to be
# shell-agnostic. Bash specifc customisations can be found in ~/.bashrc.
#
# To enable a script, add it to the list below. Scripts should be
# added alphabetically except where necessary (e.g. the two override
# scripts `platform` and `local`) and should work independentally of
# one another where possible (scripts depending on `color` being a
# notable exception).

# Some platform variables that are used by the profile.d scripts
export DOTFILES_DIR PLATFORM PS_SHELL IS_COLOR IS_INTERACTIVE IS_MACOS IS_LINUX

DOTFILES_DIR="$(dirname "$(dirname "$(realpath "$HOME"/.profile)")")"
PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')"
PS_SHELL="$(basename "$(ps -p $$ -ocomm= | tr -d '-')")"
IS_COLOR="$(tput colors > /dev/null 2>&1 && [ "$(tput colors)" -gt 2 ] && echo 1)"
IS_MACOS="$([ "$PLATFORM" = "darwin" ] && echo 1)"
IS_LINUX="$([ "$PLATFORM" = "linux" ] && echo 1)"

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
  git \
  grep \
  ip \
  ls \
  mkcd \
  ncdu \
  npm \
  nvm \
  prompt \
  python \
  rust \
  temp \
  tmux \
  top \
  tree \
  update \
  vim \
  platform \
  local \
  motd \
; do
  [ -r "$HOME/.profile.d/$_file.sh" ] && . "$HOME/.profile.d/$_file.sh"
done
unset _file

alias reload='exec "$SHELL"'

localedit() {
  ${EDITOR:-vi} "$HOME/.profile.d/local.sh" && . "$HOME/.profile.d/local.sh"
}

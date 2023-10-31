# This file contains shell agnostic customisations. It is designed
# to be read by Zsh and Bash and Bourne shell (sh) so shell specific
# syntax shoud be avoided!
#
# The customisations themselves can be found in ~/.profile.d/
#
# Bash customisations can be found in ~/.bashrc
# Zsh customisations can be found in ~/.zshrc
#
# To enable a script, add it to the list below. Scripts should be
# added alphabetically except where necessary (e.g. the two override
# scripts `platform` and `local`) and should work independentally of
# one another where possible (scripts depending on `color` being a
# notable exception).

# Some platform variables that are used by the profile.d scripts
export DOTFILES_DIR PLATFORM PS_SHELL IS_COLOR IS_INTERACTIVE IS_MACOS IS_LINUX
DOTFILES_DIR=$(dirname $(dirname $(realpath $HOME/.profile)))
PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')"
PS_SHELL="$(ps -p $$ -ocomm= | tr -d '-')"
IS_COLOR="$(tput colors > /dev/null 2>&1 && [ "$(tput colors)" -gt 2 ] && echo 1)"
IS_MACOS="$([ "$PLATFORM" = "darwin" ] && echo 1)"
IS_LINUX="$([ "$PLATFORM" = "linux" ] && echo 1)"

case $- in
  *i*) IS_INTERACTIVE=1;;
  *) ;;
esac

# Source profile.d scripts in the order specified
for file in \
  bin \
  brew \
  color \
  docker \
  git \
  grep \
  ls \
  mkcd \
  ncdu \
  npm \
  nvm \
  prompt \
  pyenv \
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
  [ -r "$HOME/.profile.d/$file.sh" ] && . "$HOME/.profile.d/$file.sh"
done

localedit() {
  ${EDITOR:-vi} "$HOME/.profile.d/local.sh" && . "$HOME/.profile.d/local.sh"
}

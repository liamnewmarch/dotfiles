# Set the default editor to Helix
if command -v hx >/dev/null; then
  export EDITOR='hx'

  alias helixedit='hx ~/.config/helix/'
  alias he='helixedit'
fi

if [ -n "$EDITOR" ]; then
  export VISUAL="$EDITOR"

  # The preferred way to edit files is to use the `edit` alias
  alias edit='$EDITOR'

  # Edit dotfiles and reload (all files)
  dotfilesedit() {
    $EDITOR "$DOTFILES_DIR" && . "$HOME/.profile"
  }
  alias dfe='dotfilesedit'


  # Edit .profile.d/local.sh and reload (just that one file)
  localedit() {
    $EDITOR "$HOME/.profile.d/local.sh" && . "$HOME/.profile.d/local.sh"
  }
  alias le='localedit'

  # The preferred way to edit files as root is to use `sudoedit`. This allows
  # us to edit files with the user’s default editor and config. macOS doesn’t
  # ship with sudoedit, so use an alias.
  if ! command -v sudoedit >/dev/null; then
    alias sudoedit='sudo -e'
  fi
fi

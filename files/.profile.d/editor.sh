# Set the default editor to Helix

if command -v hx >/dev/null; then
  export EDITOR='hx'
fi

if [ -n "$EDITOR" ]; then
  export VISUAL="$EDITOR"

  # The preferred way to edit files is to use the `edit` alias
  alias edit='$EDITOR'

  # The preferred way to edit files as root is to use `sudoedit`. This allows
  # us to edit files with the user’s default editor and config. macOS doesn’t
  # ship with sudoedit, so use an alias.
  if ! command -v sudoedit >/dev/null; then
    alias sudoedit='sudo -e'
  fi
fi

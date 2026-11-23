# Set the default editor to Helix
if command -v hx >/dev/null; then
  export EDITOR='hx'

  alias helixedit='hx ~/.config/helix/'
  alias he='helixedit'

  # Helix queries the terminal's capabilities (DECRQM and DECRQSS) on startup,
  # before switching to the alternate screen. Terminals that don't recognise
  # them (e.g. Terminal.app, Termius) print part of them as text ("p$qm"),
  # which is revealed on the normal screen when Helix exits. That text is
  # always on the cursor's line, so clear the line afterwards. This is a no-op
  # in terminals that handle the queries, where the cursor is on the empty
  # line after the command, so it isn't limited to specific terminals.
  hx() {
    local status
    command hx "$@"
    status=$?
    [ -t 1 ] && printf '\r\033[K'
    return "$status"
  }
fi

if [ -n "$EDITOR" ]; then
  export VISUAL="$EDITOR"

  # The preferred way to edit files is to use the `edit` alias
  alias edit='$EDITOR'

  # The preferred way to edit files as root is to use `sudoedit`. This allows
  # files to be edited with the default editor and config. macOS doesn’t ship
  # with sudoedit, so use an alias.
  if ! command -v sudoedit >/dev/null; then
    alias sudoedit='sudo -e'
  fi
fi

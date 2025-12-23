# Set the default editor to Helix, Vim, or vi

if command -v hx >/dev/null; then
  export EDITOR='hx'
elif command -v vim >/dev/null; then
  export EDITOR='vim'
elif command -v vi >/dev/null; then
  export EDITOR='vi'
fi

if [ -n "$EDITOR" ]; then
  alias edit='$EDITOR'
  alias vi='$EDITOR'
fi

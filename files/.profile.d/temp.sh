temp() {
  # Create a temp directory
  local tempdir prevdir
  tempdir=$(mktemp -d)
  prevdir=$(pwd)
  echo "Created temp dir $tempdir."
  cd "$tempdir" || return

  if command -v tput >/dev/null; then
    # Switch to alternate screen and repeat previous output
    tput smcup
    echo "Created temp dir $tempdir."
  fi

  printf 'Starting a new %s shell. Type exit to return.\n\n' "$SHELL"
  $SHELL

  # Remove the temp directory
  cd "$prevdir" || true
  rm -rf "$tempdir"

  if command -v tput >/dev/null; then
    # Switch to normal screen and repeat next output
    tput rmcup
  fi

  echo 'Removed temp dir.'
}

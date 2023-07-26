temp() {
  # Create a temp directory
  tempdir=$(mktemp -d)
  echo "Created temp dir $tempdir."
  pushd "$tempdir" > /dev/null || true

  if command -v tput > /dev/null; then
    # Switch to alternate screen and repeat previous output
    tput smcup
    echo "Created temp dir $tempdir."
  fi

  printf 'Starting a new %s shell. Type exit to return.\n\n' "$PS_SHELL"
  $PS_SHELL

  # Remove the temp directory
  popd > /dev/null || true
  rm -rf "$tempdir"

  if command -v tput > /dev/null; then
    # Switch to normal screen and prepeat next output
    echo 'Removed temp dir.'
    tput rmcup
  fi

  echo 'Removed temp dir.'
}

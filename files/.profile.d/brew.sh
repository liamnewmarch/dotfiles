_zsh_emulate() {
  # Run zsh emulate without breaking other shells
  type emulate >/dev/null 2>/dev/null && emulate "${1:-zsh}"
}

_brew_fix() {
  # Find where Homebrew is installed, relative paths obtained from `brew doctor`
  _brew_prefix=$(brew --prefix)
  _brew_relative_paths='bin etc sbin share share/doc'

  # Warn the user that we need to use sudo
  printf 'Claiming ownership of paths in %s (requires sudo)\n' "$(blue "$_brew_prefix")"

  # Make zsh behave like sh for this part
  _zsh_emulate sh
  _brew_paths=$(for p in $_brew_relative_paths; do echo "$_brew_prefix/$p"; done)
  _zsh_emulate

  echo "$_brew_paths" | xargs sudo chown -R "$(whoami)"
  echo "$_brew_paths" | xargs chmod u+w
  unset _brew_paths _brew_prefix _brew_relative_paths
  printf '%s\n' "$(green 'Success')"
}

_brew_full_upgrade() {
  printf 'Running %s\n' "$(magenta 'brew doctor')"

  # Offer to fix folder permissions if `brew doctor` exits with non-zero status
  if ! brew doctor; then
    printf '\n%s non-zero exit status from %s\n' "$(yellow 'Warning:')" "$(magenta 'brew doctor')"
    printf 'Attempt to fix homebrew paths? [Y/n/q] '
    read -r yn
    case $yn in
      [Yy]*|'' )
        printf '\n'  # For consistency with future commands
        brew fix
        ;;
      [Nn]* )
        printf 'Continuing\n'
        ;;
      [Qq]*|* )
        printf '%s\n' "$(red 'Aborted')"
        return 1
        ;;
    esac
  fi

  _brew_upgrade
}

_brew_upgrade() {
  # Look for --no-cleanup argument
  _cleanup=1
  case "$1" in
    --no-cleanup )
      _cleanup=0
      ;;
  esac

  # Do the upgrade
  printf '\nRunning %s\n' "$(magenta 'brew upgrade')"
  command brew upgrade

  # Clean up, unless the user asked not to
  if [ $_cleanup -gt 0 ]; then
    printf 'Running %s\n' "$(magenta 'brew cleanup')"
    brew cleanup --prune=all
  fi
  unset _cleanup
  printf '%s\n' "$(green 'Success')"
}

brew() {
  case "$1" in
    fix )
      _brew_fix
      ;;
    full-upgrade )
      _brew_full_upgrade
      ;;
    upgrade )
      _brew_upgrade "$@"
      ;;
    * )
      command brew "$@"
      ;;
  esac
  return $?
}

alias b='brew'
alias bfix='_brew_fix'
alias bcl='brew clean --prune=all'
alias bi='brew install'
alias bl='brew leaves'
alias bls='brew list'
alias blt='_brew_ls_tree'
alias bo='brew outdated'
alias bun='brew uninstall'
alias bup='_brew_upgrade'

_brew_fix() {
  # Find where Homebrew is installed, relative paths obtained from `brew doctor`
  _brew_prefix=$(brew --prefix)
  _brew_relative_paths='bin etc sbin share share/doc'

  # Warn the user that we need to use sudo
  printf 'Claiming ownership of paths in %s (requires sudo)\n' "$(blue "$_brew_prefix")"

  # Make zsh behave like sh for this part
  for _path in $_brew_relative_paths; do
    _path="$_brew_prefix/$_path"
    sudo chown -R "$(whoami)" "$_path"
    chmod u+w "$_path"
    unset _path
  done
  unset _brew_paths _brew_prefix _brew_relative_paths
  printf '%s\n' "$(green 'Success')"
}

_brew_ls_tree() {
  for package in $(brew leaves); do
    brew desc "$package"
    brew deps --tree "$package" | tail -n +2
  done
}

_brew_upgrade() {
  # Look for --no-cleanup argument
  _cleanup=1

  for arg; do
    shift
    case "$arg" in
      --no-cleanup )
        _cleanup=0
        ;;
      --help )
        _cleanup=0
        set -- "$@" "$arg"
        ;;
      * )
        set -- "$@" "$arg"
        ;;
    esac
  done

  # Do the upgrade
  printf '\nRunning %s\n' "$(magenta 'brew upgrade')"
  command brew upgrade "$@"

  # Clean up, unless the user asked not to
  if [ $_cleanup -gt 0 ]; then
    printf 'Running %s\n' "$(magenta 'brew cleanup')"
    brew cleanup --prune=all
  fi
  unset _cleanup
  printf '%s\n' "$(green 'Success')"
}

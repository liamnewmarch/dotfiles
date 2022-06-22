# Homebrew is installed to /opt on arm64 which not in PATH
if [ -d /opt/homebrew/bin ]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

# Return early if brew is not defined
if ! command -v brew >/dev/null; then
  return
fi

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_INSTALL_UPGRADE=1

alias b='brew'
alias bfix='_brew_fix'
alias bcl='brew cleanup --prune=all'
alias bi='brew install'
alias bl='brew leaves'
alias bls='brew list'
alias blt='_brew_ls_tree'
alias bo='brew outdated'
alias bun='brew uninstall'
alias bup='_brew_upgrade'

_zsh_emulate() {
  # Run zsh emulate without breaking other shells
  type emulate >/dev/null 2>/dev/null && emulate "${1:-zsh}"
}

_brew_fix() {
  # Find where Homebrew is installed, relative paths obtained from `brew doctor`
  _brew_prefix=$(brew --prefix)

  # Warn the user that we need to use sudo
  printf 'Claiming ownership of paths in %s (requires sudo)\n' "$(blue "$_brew_prefix")"

  # Make zsh behave like sh for this part
  for _path in bin etc sbin share share/doc; do
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

# Homebrew is installed to /opt on arm64 which not in PATH
if [ -d /opt/homebrew/bin ]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

# Return early if brew is not defined
if ! command -v brew >/dev/null; then
  return
fi

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSTALL_UPGRADE=1

alias b='brew'
alias bar='brew autoremove'
alias bcl='brew cleanup --prune=all'
alias bfix='_brew_fix'
alias bi='brew install'
alias bl='brew leaves'
alias bls='brew list'
alias bo='brew outdated'
alias bud='brew update'
alias bun='brew uninstall'
alias bup='brew upgrade'

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

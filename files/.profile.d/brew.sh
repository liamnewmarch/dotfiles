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

alias bar='brew autoremove'
alias bcl='brew cleanup --prune=all'
alias bi='brew install'
alias bl='brew leaves'
alias bls='brew list'
alias bo='brew outdated'
alias bud='brew update'
alias bun='brew uninstall'
alias bup='brew upgrade'

# Enable bash completions
for _completion in "$(brew --prefix)/etc/bash_completion.d/"*; do
  source "${_completion}"
done
unset _completion

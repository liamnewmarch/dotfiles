export NVM_DIR="$HOME/.nvm"

if [ -d "$NVM_DIR" ]; then
  # Lazy-load nvm
  nvm() {
    unset -f nvm
    if command -v brew > /dev/null; then
      _brew_nvm=$(brew --prefix nvm)
      . "$_brew_nvm/nvm.sh"
      . "$_brew_nvm/etc/bash_completion.d/nvm"
      unset _brew_nvm
    else
      . "$NVM_DIR/nvm.sh"
      . "$NVM_DIR/bash_completion"
    fi
    nvm "$@"
  }
fi

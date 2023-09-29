export NVM_DIR="$HOME/.nvm"

if [ -d "$NVM_DIR" ]; then
  # Lazy-load nvm
  nvm() {
    unset -f nvm
    . "$NVM_DIR/nvm.sh"
    . "$NVM_DIR/bash_completion"
    nvm "$@"
  }
fi

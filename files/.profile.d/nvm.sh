export NVM_DIR="$HOME/.nvm"

if [ -d "$NVM_DIR" ]; then
  try-source "$NVM_DIR/nvm.sh"
  if [ -n "$BASH_VERSION" ]; then
    try-source "$NVM_DIR/bash_completion"
  fi
fi

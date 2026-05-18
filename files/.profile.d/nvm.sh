export NVM_DIR="$HOME/.nvm"

if [ -d "$NVM_DIR" ]; then
  try-source "$NVM_DIR/nvm.sh"
  try-source "$NVM_DIR/bash_completion"
fi

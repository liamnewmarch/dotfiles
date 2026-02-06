if [ -d /opt/homebrew/bin ]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

# Return early if brew is not defined
if ! command -v brew >/dev/null; then
  return
fi

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSTALL_UPGRADE=1

try-source "$(brew --prefix)/etc/profile.d/bash_completion.sh"

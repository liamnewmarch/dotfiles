if ! [ -d /opt/homebrew/bin ]; then
  return
fi

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSTALL_UPGRADE=1

if [ -n "$BASH_VERSION" ]; then
  # Export env vars like HOMEBREW_PREFIX so `brew --prefix` isn’t necessary
  eval "$(/opt/homebrew/bin/brew shellenv bash)"

  # Load completions, adapted from https://docs.brew.sh/Shell-Completion#Bash
  if ! try_source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"; then
    for _completion in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      try_source "$_completion"
    done
    unset _completion
  fi
fi

_sudo_check() {
  local _default _sudo_disabled _sudo_exists

  _default=${1:-false}  # Whether to print sudo if other checks pass
  _sudo_disabled=${NO_SUDO:-false}  # Whether the NO_SUDO flag has been set
  _sudo_exists=$(command -v sudo >/dev/null)  # Whether sudo exists in PATH

  if $_default && $_sudo_exists && ! $_sudo_disabled; then
    printf 'sudo'
  fi
}

update() {
  local _sudo

  # Update APT packages
  if command -v apt-get >/dev/null; then
    _sudo=$(_sudo_check "${SUDO_APT:-true}")
    $_sudo apt-get update
    $_sudo apt-get upgrade --autoremove --quiet --yes
  fi

  # Update Homebrew packages
  if command -v brew >/dev/null; then
    _sudo=$(_sudo_check "${SUDO_BREW:-false}")
    $_sudo brew update
    $_sudo brew upgrade
    $_sudo brew cleanup --prune=all
  fi

  # Update global npm packges
  if command -v npm >/dev/null; then
    _sudo=$(_sudo_check "${SUDO_NPM:-false}")
    $_sudo npm -g update
  fi
}

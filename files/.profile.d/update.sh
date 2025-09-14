_sudo_check() {
  _default=${1:-false}  # Whether to print sudo if other checks pass
  _sudo_disabled=${NO_SUDO:-false}  # Whether the NO_SUDO flag has been set
  _sudo_exists=$(command -v sudo >/dev/null)  # Whether sudo exists in PATH

  if $_default && $_sudo_exists && ! $_sudo_disabled; then
    printf 'sudo'
  fi

  unset _default _sudo_disabled _sudo_exists
}

update() {
  # Update dotfiles
  if command -v git >/dev/null; then
    printf '%s\n' "$(color blue 'Updating dotfiles')"
    _sudo=$(_sudo_check "${SUDO_GIT:-false}")
    $_sudo git -C "$HOME/.profile.d" pull --ff-only --no-rebase
  fi

  # Update APT packages
  if command -v apt-get >/dev/null; then
    printf '%s\n' "$(color blue 'Updating apt packages')"
    _sudo=$(_sudo_check "${SUDO_APT:-true}")
    $_sudo apt-get update
    $_sudo apt-get upgrade --autoremove --quiet --yes
  fi

  # Update Homebrew packages
  if command -v brew >/dev/null; then
    printf '%s\n' "$(color blue 'Updating brew packages')"
    _sudo=$(_sudo_check "${SUDO_BREW:-false}")
    $_sudo brew update
    $_sudo brew upgrade
    $_sudo brew cleanup --prune=all
  fi

  # Check if the system should be restarted
  if [ -r /var/run/reboot-required ]; then
    printf '%s\n' "$(color yellow 'Reboot required')"
    if [ -r /var/run/reboot-required.pkgs ]; then
      cat /var/run/reboot-required.pkgs
    fi
  fi

  unset _sudo
}

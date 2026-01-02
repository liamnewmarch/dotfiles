update() {
  # Update dotfiles
  if command -v git >/dev/null; then
    printf '%s\n' "$(color blue 'Updating dotfiles')"
    git -C "$HOME/.profile.d" pull --autostash --ff-only --no-rebase
  fi

  # Update APT packages
  if command -v apt-get >/dev/null; then
    printf '%s\n' "$(color blue 'Updating apt packages')"
    sudo apt update
    sudo apt upgrade --autoremove --quiet --yes
  fi

  # Update Homebrew packages
  if command -v brew >/dev/null; then
    printf '%s\n' "$(color blue 'Updating brew packages')"
    brew update
    brew upgrade
    brew cleanup --prune=all
  fi

  # Check if the system should be restarted
  if [ -r /var/run/reboot-required ]; then
    printf '%s\n' "$(color yellow 'Reboot required')"
    if [ -r /var/run/reboot-required.pkgs ]; then
      cat /var/run/reboot-required.pkgs
    fi
  fi
}

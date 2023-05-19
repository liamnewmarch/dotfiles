update() {
  if command -v apt >/dev/null; then
    sudo apt update
    sudo apt --autoremove --quiet --yes upgrade
  fi

  if command -v brew >/dev/null; then
    brew update
    brew upgrade
    brew cleanup --prune=all
  fi

  if command -v npm >/dev/null; then
    npm -g update
  fi
}

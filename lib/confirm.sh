# Shared confirmation prompt used by install.sh and uninstall.sh.

# Prompt the user for confirmation
confirm() {
  local reply
  read -r -p "$1 [y/N] " reply || return 1
  case "$reply" in
    [yY][eE][sS]|[yY])
      true
      ;;
    *)
      false
      ;;
  esac
}

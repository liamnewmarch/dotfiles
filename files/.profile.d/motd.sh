motd() {
  local _host _shell _user
  _host=${HOST_NICKNAME:-${HOSTNAME:-${HOST:-'localhost'}}}
  _shell=$(basename "$SHELL")
  _user=${USER:-'user'}

  printf '%s as %s on %s\n' "$(color red "$_shell")" "$(color blue "$_user")" "$(color magenta "$_host")"
}

# Show message of the day
[ -n "$IS_INTERACTIVE" ] && motd

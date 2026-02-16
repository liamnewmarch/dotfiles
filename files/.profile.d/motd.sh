motd() {
  _host=${HOST_NICKNAME:-${HOSTNAME:-${HOST:-localhost}}}
  _shell=${PS_SHELL:-$SHELL}
  _user=${USER:-'user'}

  printf '%s\n' "$(color red "$_shell") as $(color blue "$_user") on $(color magenta "$_host")"

  unset _host _shell _user
}

# Show message of the day
[ -n "$IS_INTERACTIVE" ] && motd

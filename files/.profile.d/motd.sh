motd() {
  local _host _shell _user

  _host=${HOST_NICKNAME:-${HOSTNAME:-${HOST:-localhost}}}
  _shell=${PS_SHELL:-$SHELL}
  _user=${USER:-'user'}

  printf '%s\n' "$(red "$_shell") as $(blue "$_user") on $(magenta "$_host")"

  if [ -n "$IS_INTERACTIVE" ] && [ -z "$TMUX" ]; then
    num_tmux="$(_tmux_num_sessions)"
    [ -z "$num_tmux" ] || [ "$num_tmux" -eq 0 ] && return
    if [ "$num_tmux" -eq 1 ]; then
      printf '\n%s\n' "$(yellow '•') There is $(blue '1') active tmux session"
    else
      printf '\n%s\n' "$(yellow '•') There are $(blue "$num_tmux") active tmux sessions"
    fi
  fi
}

# Show message of the day
[ -n "$IS_INTERACTIVE" ] && motd

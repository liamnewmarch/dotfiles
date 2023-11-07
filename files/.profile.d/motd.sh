motd() {
  local _host _shell _user

  _host=${HOST_NICKNAME:-${HOSTNAME:-${HOST:-localhost}}}
  _shell=${PS_SHELL:-$SHELL}
  _user=${USER:-'user'}

  printf '%s\n' "$(color red "$_shell") as $(color blue "$_user") on $(color magenta "$_host")"

  if [ -n "$IS_INTERACTIVE" ] && [ -z "$TMUX" ]; then
    num_tmux="$(_tmux_num_sessions)"
    [ -z "$num_tmux" ] || [ "$num_tmux" -eq 0 ] && return
    if [ "$num_tmux" -eq 1 ]; then
      printf '\n%s\n' "$(color yellow '•') There is $(color blue '1') active tmux session"
    else
      printf '\n%s\n' "$(color yellow '•') There are $(color blue "$num_tmux") active tmux sessions"
    fi
  fi
}

# Show message of the day
[ -n "$IS_INTERACTIVE" ] && motd

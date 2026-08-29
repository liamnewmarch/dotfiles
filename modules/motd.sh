motd() {
  local _host _num_tmux _shell _user
  _host=${HOST_NICKNAME:-${HOSTNAME:-${HOST:-'localhost'}}}
  _shell=$(basename "$SHELL")
  _user=${USER:-'user'}

  printf '%s as %s on %s\n' "$(color red "$_shell")" "$(color blue "$_user")" "$(color magenta "$_host")"

  if [ -n "$IS_INTERACTIVE" ] && [ -z "$TMUX" ]; then
    _num_tmux="$(_tmux_num_sessions)"
    [ -z "$_num_tmux" ] || [ "$_num_tmux" -eq 0 ] && return
    if [ "$_num_tmux" -eq 1 ]; then
      printf '\n%s\n' "$(color yellow '•') There is $(color blue '1') active tmux session"
    else
      printf '\n%s\n' "$(color yellow '•') There are $(color blue "$_num_tmux") active tmux sessions"
    fi
  fi
}

# Show message of the day
[ -n "$IS_INTERACTIVE" ] && [ -z "$DOTFILES_SKIP_MOTD" ] && motd

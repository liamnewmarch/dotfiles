_tmux_num_sessions() {
  if command -v tmux >/dev/null; then
    tmux list-sessions 2>/dev/null | wc -l | tr -d '[:space:]'
  else
    printf 0
  fi
}

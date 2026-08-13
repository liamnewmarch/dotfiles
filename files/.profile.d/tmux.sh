_tmux_num_sessions() {
  if command -v tmux >/dev/null; then
    tmux start-server \; list-sessions | wc -l | tr -d '[:space:]'
  else
    printf 0
  fi
}

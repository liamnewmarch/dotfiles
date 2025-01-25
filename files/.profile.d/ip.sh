if ! command -v curl >/dev/null; then
  return
fi

alias whatsmyip='curl http://ip.nwmr.ch'

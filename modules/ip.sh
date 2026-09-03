if ! command -v curl >/dev/null; then
  return
fi

alias whatsmyip='curl https://ip.nwmr.ch'

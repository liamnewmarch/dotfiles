if ! command -v htop >/dev/null; then
  return
fi

alias top='htop'

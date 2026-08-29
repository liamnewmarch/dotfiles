# Return early if htop is not defined
if ! command -v htop >/dev/null; then
  return
fi

alias top='htop'

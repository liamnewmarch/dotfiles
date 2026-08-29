# Return early if grep is not defined
if ! command -v grep >/dev/null; then
  return
fi

alias grep='grep --color=auto'

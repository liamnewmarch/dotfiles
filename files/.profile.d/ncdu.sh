# Return early if ncdu is not defined
if ! command -v ncdu >/dev/null; then
  return
fi

alias ncdu='ncdu --color dark -rr -x --exclude .git --exclude node_modules'

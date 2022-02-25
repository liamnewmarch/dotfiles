# Return early if tree is not defined
if ! command -v tree >/dev/null; then
  return
fi

alias tree='tree -I node_modules'

if command -v lsd >/dev/null; then
  alias tree='lsd --tree -I node_modules'
elif command -v tree >/dev/null; then
  alias tree='tree -I node_modules'
fi

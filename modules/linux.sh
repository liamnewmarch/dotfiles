if command -v xdg-open >/dev/null; then
  export BROWSER='xdg-open'

  alias browse='$BROWSER'
fi

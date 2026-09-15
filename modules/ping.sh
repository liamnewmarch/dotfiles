if ! command -v prettyping >/dev/null; then
  return
fi

alias ping='prettyping --nolegend'

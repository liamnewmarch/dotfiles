# Bash completions live in a separate file to keep dotfiles.sh POSIX-ish

_dotfiles_complete_module() {
  local names name
  names='local'
  for name in "$(dotfiles path)"/modules/*.sh; do
    names="$names $(basename "$name" .sh)"
  done
  # shellcheck disable=SC2207
  COMPREPLY=( $(compgen -W "$names" -- "$1") )
}

_dotfiles_complete() {
  local cur prev
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  if [ "$COMP_CWORD" -eq 1 ]; then
    # shellcheck disable=SC2207
    COMPREPLY=( $(compgen -W 'doctor edit help path reload reset restart update' -- "$cur") )
  elif [ "$prev" = edit ]; then
    _dotfiles_complete_module "$cur"
  fi
}

# dfe is `dotfiles edit`, so its first argument is a module name, not a subcommand
_dfe_complete() {
  _dotfiles_complete_module "${COMP_WORDS[COMP_CWORD]}"
}

complete -F _dotfiles_complete dotfiles
complete -F _dfe_complete dfe

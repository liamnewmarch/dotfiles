# Simple prompt
export PS1='
\t
\W
\$ '

export PS2='… '

# Simple color prompt
if [ -n "$IS_COLOR" ]; then
  PS1="
\t
$(color blue '\W')
$(color blue '\$') "
  PS2="$(color blue '…') "
fi

# Fancy color prompt
if [ -n "$IS_COLOR" ]; then
  PROMPT_COMMAND=_prompt_command
fi

_prompt_command() {
  PS1="
\t $(_prompt_error)
$(color blue '\W')$(_prompt_git_branch)
$(_prompt_virtualenv)$(_prompt_ssh)$(color blue '\$') "
}

_prompt_git_branch() {
  [ -z "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ] && return
  branch="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"
  modified="$(git status --porcelain | wc -l | tr -d '[:space:]')"
  printf ' ⌥ %s' "$(color green "$branch")"
  [ "$modified" -gt 0 ] && printf ' (%s)' "$(color red "$modified")"
}

_prompt_error() {
  # shellcheck disable=SC2181
  [ $? -ne 0 ] && printf '%s' "$(color red '⨯')"
}

_prompt_ssh() {
  [ -n "$SSH_CLIENT" ] && printf '%s ' "$(color yellow '•')"
}

_prompt_virtualenv() {
  [ -n "$VIRTUAL_ENV" ] && printf '(%s) ' "$(basename "$VIRTUAL_ENV")"
}

# Simple prompt
export PS1='
\t
\W
\$ '

export PS2='… '

# Color prompt
if [ -n "$IS_COLOR" ]; then
  PS1='${dotfiles_prompt_err}
$(color grey '"'\t'"')
${dotfiles_prompt_ssh}$(color blue '"'\W'"')${dotfiles_prompt_git}
${dotfiles_prompt_env}$(color blue '"'\$'"') '

  PS2='$(color grey …) '

  PROMPT_COMMAND='dotfiles_prompt_command'
fi

export dotfiles_prompt_env=''
export dotfiles_prompt_err=''
export dotfiles_prompt_git=''
export dotfiles_prompt_ssh=''

dotfiles_prompt_command() {
  dotfiles_prompt_err=$(_dotfiles_prompt_err $?)
  dotfiles_prompt_git=$(_dotfiles_prompt_git)
  dotfiles_prompt_ssh=$(_dotfiles_prompt_ssh)
}

_dotfiles_prompt_git() {
  [ -z "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ] && return
  branch="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"
  modified="$(git status --porcelain | wc -l | tr -d '[:space:]')"
  printf ' ⌥ %s' "$(color green "$branch")"
  [ "$modified" -gt 0 ] && printf ' (%s)' "$(color red "$modified")"
}

_dotfiles_prompt_err() {
  [ $1 -gt 0 ] && printf '\n%s %s' "$(color grey "Exit status:")" "$(color red "$1")"
}

_dotfiles_prompt_ssh() {
  [ -n "$SSH_CLIENT" ] && printf '%s ' "$(color yellow '•')"
}

_dotfiles_prompt_env() {
  [ -n "$VIRTUAL_ENV" ] && printf '(%s) ' "$(basename "$VIRTUAL_ENV")"
}

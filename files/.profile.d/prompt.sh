export DOTFILES_PROMPT_CONTINUATION='…'
export DOTFILES_PROMPT_DIRECTORY='\W'
export DOTFILES_PROMPT_TERMINATOR='\$'
export DOTFILES_PROMPT_TIME='\t'

# Simple monochrome prompt
export PS1="
$DOTFILES_PROMPT_TIME
$DOTFILES_PROMPT_DIRECTORY
$DOTFILES_PROMPT_TERMINATOR "

export PS2="$DOTFILES_PROMPT_CONTINUATION "

# Return early if the prompt doesn‘t support colour
if [ ! "$IS_COLOR" ]; then return; fi

# Colourise simple values
DOTFILES_PROMPT_CONTINUATION=$(color grey "$DOTFILES_PROMPT_CONTINUATION")
DOTFILES_PROMPT_DIRECTORY=$(color blue "$DOTFILES_PROMPT_DIRECTORY")
DOTFILES_PROMPT_TERMINATOR=$(color blue "$DOTFILES_PROMPT_TERMINATOR")
DOTFILES_PROMPT_TIME=$(color grey "$DOTFILES_PROMPT_TIME")

# Simple coloured prompt
PS1="
$DOTFILES_PROMPT_TIME
$DOTFILES_PROMPT_DIRECTORY
$DOTFILES_PROMPT_TERMINATOR "

PS2="$DOTFILES_PROMPT_CONTINUATION "

# Return early if the prompt isn’t interactive
if [ ! "$IS_INTERACTIVE" ]; then return; fi

# Dynamic values are assigned by the PROMPT_COMMAND, see _dotfiles_prompt_command below
export DOTFILES_PROMPT_ERROR
export DOTFILES_PROMPT_GIT
export DOTFILES_PROMPT_SSH
export DOTFILES_PROMPT_VIRTUAL_ENV
export PROMPT_COMMAND='_dotfiles_prompt_command'

# Dynamic coloured prompt
#
# This looks a bit weird, but basically:
#
# * Variables beginning $ are evaluated once, now
# * Variables beginning \$ are evaluated every time the prompt is printed
PS1="\$DOTFILES_PROMPT_ERROR
$DOTFILES_PROMPT_TIME
\$DOTFILES_PROMPT_SSH$DOTFILES_PROMPT_DIRECTORY\$DOTFILES_PROMPT_VIRTUAL_ENV\$DOTFILES_PROMPT_GIT
$DOTFILES_PROMPT_TERMINATOR "

# This command runs before the PS1 is printed to update dynamic values
_dotfiles_prompt_command() {
  DOTFILES_PROMPT_ERROR=$(_dotfiles_update_prompt_error $?)
  DOTFILES_PROMPT_GIT=$(_dotfiles_update_prompt_git)
  DOTFILES_PROMPT_SSH=$(_dotfiles_update_prompt_ssh)
  DOTFILES_PROMPT_VIRTUAL_ENV=$(_dotfiles_update_prompt_virtual_env)
}

# Show the exit status of the last command if non-zero
_dotfiles_update_prompt_error() {
  local exit_status="$1"
  if [ "$exit_status" -gt 0 ]; then
    printf '\n%s %s' "$(color grey "Exit status:")" "$(color red "$exit_status")"
  fi
}

# If the current directory is a Git repo, show the current branch and number of modified files, if any
_dotfiles_update_prompt_git() {
  local branch modified
  if [ -n "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
    branch="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"
    modified="$(git status --porcelain | wc -l | tr -d '[:space:]')"
    printf ' ⌥ %s' "$(color green "$branch")"
    if [ "$modified" -gt 0 ]; then
      printf ' (%s)' "$(color red "$modified")"
    fi
  fi
}

# Show an indicator if this is an SSH session
_dotfiles_update_prompt_ssh() {
  if [ -n "$SSH_CLIENT" ]; then
    printf '%s ' "$(color yellow '»')"
  fi
}

# If a Python virtual env is active, print the name of it
_dotfiles_update_prompt_virtual_env() {
  if [ -n "$VIRTUAL_ENV" ]; then
    printf ' (%s)' "${VIRTUAL_ENV_PROMPT:-"$(basename "$VIRTUAL_ENV")"}"
  fi
}
# (and disable the default venv prompt which is simply prepended to PS1)
export VIRTUAL_ENV_DISABLE_PROMPT=1

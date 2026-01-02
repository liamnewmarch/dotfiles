[ -z "$DOTFILES_BASH_INIT" ] && [ -r "$HOME/.profile" ] && . "$HOME/.profile"

# Prevent double initialisation
export DOTFILES_BASH_INIT=1

# Disable the bash deprecation warning on macOS
export BASH_SILENCE_DEPRECATION_WARNING=1

set -o noclobber

shopt -s checkwinsize
shopt -s cmdhist
shopt -s failglob
shopt -s globstar
shopt -s histappend
shopt -s nocaseglob

# History settings
PROMPT_COMMAND="$PROMPT_COMMAND; history -a"
HISTSIZE=
HISTFILESIZE=
HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

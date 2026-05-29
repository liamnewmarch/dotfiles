[ -r "$HOME/.profile" ] && . "$HOME/.profile"

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
export HISTSIZE=
export HISTFILESIZE=
export HISTCONTROL='erasedups:ignoreboth'
export HISTIGNORE='&:[ ]*:exit:ls:bg:fg:history:clear'

# Reset PROMPT_COMMAND, allowing .bashrc to be sourced multiple times e.g. by `dotfiles reload`
export DOTFILES_INITIAL_PROMPT_COMMAND="${DOTFILES_INITIAL_PROMPT_COMMAND:-"$PROMPT_COMMAND"}"
# Append `history -a` to the PROMPT_COMMAND with a semicolon if necessary
export PROMPT_COMMAND="${DOTFILES_INITIAL_PROMPT_COMMAND:+"$DOTFILES_INITIAL_PROMPT_COMMAND; "}history -a"

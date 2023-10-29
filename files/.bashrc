[ -z "$DOTFILES_BASH_INIT" ] && [ -r "$HOME/.profile" ] && . "$HOME/.profile"

# Prevent double initialisation
export DOTFILES_BASH_INIT=1

# Disable the bash deprecation warning on macOS
export BASH_SILENCE_DEPRECATION_WARNING=1

shopt -s checkwinsize
shopt -s failglob
shopt -s globstar
shopt -s histappend
shopt -s nocaseglob

# Load Homebrew bash completions if available
if [ -r /usr/local/etc/bash_completion.d ]; then
  for file in /usr/local/etc/bash_completion.d/*; do
    . "$file"
  done
fi

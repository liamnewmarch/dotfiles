export PYENV_ROOT="$HOME/.pyenv"

if [ -d "$PYENV_ROOT" ]; then
  pyenv() {
    unset -f pyenv
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  }
fi

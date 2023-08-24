# Return early if python3 is not defined
if ! command -v python3 >/dev/null; then
  return
fi

export PYTHONDONTWRITEBYTECODE=1
export PYTHONPYCACHEPREFIX="$HOME/.cache/python"
export VIRTUAL_ENV_DISABLE_PROMPT=1
export VIRTUALENVWRAPPER_PYTHON

# Add unversioned Homebrew Python to PATH
if command -v brew >/dev/null; then
  if [ -d "$(brew --prefix)/opt/python" ]; then
    export PATH
    PATH="$(brew --prefix python)/libexec/bin:$PATH"
  fi
fi

alias serve='python3 -m http.server'
VIRTUALENVWRAPPER_PYTHON="$(which python3)"

# Return early if python3 is not defined
if ! command -v python3 >/dev/null; then
  return
fi

export PYTHONDONTWRITEBYTECODE='true'
export PYTHONPYCACHEPREFIX="$HOME/.cache/python"
export VIRTUALENVWRAPPER_PYTHON="$(which python3)"
export VIRTUAL_ENV_DISABLE_PROMPT=1

alias serve='python3 -m http.server'

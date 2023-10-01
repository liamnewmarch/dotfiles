# Return early if python3 is not defined
if ! command -v python3 >/dev/null; then
  return
fi

export PYTHONDONTWRITEBYTECODE=1
export PYTHONPYCACHEPREFIX="$HOME/.cache/python"
export VIRTUAL_ENV_DISABLE_PROMPT=1

alias serve='python3 -m http.server'

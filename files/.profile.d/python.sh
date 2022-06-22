# Return early if python3 is not defined
if ! command -v python3 >/dev/null; then
  return
fi

export PYTHONDONTWRITEBYTECODE=1
export PYTHONPYCACHEPREFIX="$HOME/.cache/python"
export VIRTUAL_ENV_DISABLE_PROMPT=1
export VIRTUALENVWRAPPER_PYTHON

# Add all Homebrew Python versions into the PATH
if command -v brew >/dev/null; then
  for _python_path in "$(brew --prefix)"/opt/python@3.*/bin; do
    if [ -d "$_python_path" ]; then
      export PATH="$PATH:$_python_path"
    fi
  done
  unset _python_path
fi

alias serve='python3 -m http.server'
VIRTUALENVWRAPPER_PYTHON="$(which python3)"

if command -v uv >/dev/null; then
  alias python='uv run python'
  alias django='uv run manage.py'
elif ! command -v python >/dev/null && command -v python3 >/dev/null; then
  alias python='python3'
fi

if command -v python >/dev/null; then
  export PYTHONDONTWRITEBYTECODE=1
  export PYTHONPYCACHEPREFIX="$HOME/.cache/python"

  alias serve='python -m http.server'
fi

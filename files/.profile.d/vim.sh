# Return early if vim is not defined
if ! command -v vim >/dev/null; then
  return
fi

export EDITOR='vim'

alias vi='vim'

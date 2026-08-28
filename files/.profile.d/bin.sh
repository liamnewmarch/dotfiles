# `~/.local/bin` holds `uv tool` and `npm --global` installs (see ~/.npmrc)
for _dir in "$HOME/bin" "$HOME/.local/bin"; do
  [ -d "$_dir" ] && export PATH="$_dir:$PATH"
done
unset _dir

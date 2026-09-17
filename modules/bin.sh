# `~/.local/bin` holds `uv tool` and `npm --global` installs (see ~/.npmrc)
for _dir in "$HOME/.local/bin" "$HOME/bin"; do
  [ -d "$_dir" ] && export PATH="$_dir:$PATH"
done
unset _dir

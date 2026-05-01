_dotfiles_doctor_link() {
  local rel="$1"
  local home_path="$HOME/$rel"
  local expected="$2/files/$rel"
  if [ ! -L "$home_path" ] && [ ! -e "$home_path" ]; then
    printf '  %s ~/%s %s\n' "$(color grey '–')" "$rel" "$(color grey '(not linked)')"
    return
  fi
  if [ ! -L "$home_path" ]; then
    printf '  %s ~/%s %s\n' "$(color red '✗')" "$rel" "$(color grey '(not a symlink)')"
    _dotfiles_doctor_failed=1
    return
  fi
  local actual; actual="$(readlink "$home_path")"
  if [ "$actual" = "$expected" ]; then
    printf '  %s ~/%s\n' "$(color green '✓')" "$rel"
  else
    printf '  %s ~/%s %s\n' "$(color red '✗')" "$rel" "$(color grey "→ $actual")"
    _dotfiles_doctor_failed=1
  fi
}

_dotfiles_doctor_tool() {
  if command -v "$1" >/dev/null; then
    printf '%s ' "$(color green "$1")"
  else
    printf '%s ' "$(color grey "$1")"
  fi
}

_dotfiles_doctor() {
  local _dotfiles_doctor_failed=0
  local path; path="$(dotfiles path)"

  printf '\n%s\n' "$(color blue 'Symlinks')"
  local rel
  for rel in \
    .profile \
    .profile.d \
    .inputrc \
    .bash_profile \
    .bashrc \
    .gitconfig \
    .gitignore \
    .config/ghostty/config \
    .config/ghostty/themes/llama \
    .config/helix/config.toml \
    .config/helix/languages.toml \
    .config/helix/themes/llama.toml \
  ; do
    _dotfiles_doctor_link "$rel" "$path"
  done

  printf '\n%s\n' "$(color blue 'Repo')"
  if [ -z "$(git -C "$path" status --porcelain)" ]; then
    printf '  %s Working tree clean\n' "$(color green '✓')"
  else
    printf '  %s Working tree has uncommitted changes\n' "$(color red '✗')"
    _dotfiles_doctor_failed=1
  fi
  local counts behind ahead
  counts="$(git -C "$path" rev-list --left-right --count '@{u}...HEAD' 2>/dev/null)"
  if [ -n "$counts" ]; then
    behind="$(printf '%s' "$counts" | cut -f1)"
    ahead="$(printf '%s' "$counts" | cut -f2)"
    if [ "$behind" -gt 0 ]; then
      printf '  %s %s commit(s) behind upstream (run `dotfiles update`)\n' "$(color red '✗')" "$behind"
      _dotfiles_doctor_failed=1
    elif [ "$ahead" -gt 0 ]; then
      printf '  %s %s commit(s) ahead of upstream\n' "$(color grey '–')" "$ahead"
    else
      printf '  %s Up to date with upstream\n' "$(color green '✓')"
    fi
  else
    printf '  %s No upstream tracking branch\n' "$(color grey '–')"
  fi

  printf '\n%s\n' "$(color blue 'Tools')"
  printf '  required:   '
  local cmd
  for cmd in bash git; do _dotfiles_doctor_tool "$cmd"; done
  printf '\n  configured: '
  for cmd in hx ghostty; do _dotfiles_doctor_tool "$cmd"; done
  printf '\n  optional:   '
  for cmd in brew docker curl ncdu npm prettyping uv python htop tree; do
    _dotfiles_doctor_tool "$cmd"
  done
  printf '\n\n'

  return "$_dotfiles_doctor_failed"
}

dotfiles() {
  case $1 in
    ''|help|'-h'|'--help')
      echo 'Usage: dotfiles [ doctor | edit | help | path | reload | reset | restart | update ]'
      ;;
    doctor)
      _dotfiles_doctor
      ;;
    edit)
      local path
      if [ -n "$2" ]; then
        path="$(dotfiles path)/files/.profile.d/$2.sh"
        # shellcheck source=/dev/null
        $EDITOR "$path" && . "$path"
      else
        path="$(dotfiles path)/"
        $EDITOR "$path" && dotfiles restart
      fi
      ;;
    path)
      dirname "$(dirname "$(realpath "$HOME"/.profile)")"
      ;;
    reload)
      # shellcheck source=/dev/null
      . "$HOME/.profile"
      ;;
    reset|restart)
      clear
      exec env -i HOME="$HOME" LANG="$LANG" SHELL="$SHELL" TERM="$TERM" USER="$USER" "$SHELL" -li
      ;;
    update)
      git -C "$(dotfiles path)" pull --autostash --ff-only --no-rebase
      ;;
    *)
      printf 'Dotfiles: unknown subcommand %s\n' "$1"
      dotfiles help
      return 1
  esac
}

alias dfe='dotfiles edit'
alias dfl='dotfiles edit local'

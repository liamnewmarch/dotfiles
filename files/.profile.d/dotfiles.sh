dotfiles() {
  case $1 in
    ''|help|'-h'|'--help')
      echo 'Usage: dotfiles [ edit | help | path | reload | reset | restart | update ]'
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
    prompt)
      dotfiles_prompt_err=$(_dotfiles_prompt_err $?)
      dotfiles_prompt_git=$(_dotfiles_prompt_git)
      dotfiles_prompt_ssh=$(_dotfiles_prompt_ssh)
      export dotfiles_prompt_err dotfiles_prompt_git dotfiles_prompt_ssh
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

color() {
  # \001/\002 mark a region as non-printing so bash's line editor doesn't
  # miscount the terminal width - but they're only meaningful inside PS1.
  # Everywhere else (motd, dotfiles doctor, echoed output, ...) they're stray
  # control bytes, so only emit them when the caller is building a prompt
  # (modules/prompt.sh sets DOTFILES_COLOR_PROMPT around those calls).
  local n fmt='%s'
  [ -n "$DOTFILES_COLOR_PROMPT" ] && fmt='\001%s\002'
  [ -n "$IS_COLOR" ] && case $1 in
    black  ) n=0 ;;
    red    ) n=1 ;;
    green  ) n=2 ;;
    yellow ) n=3 ;;
    blue   ) n=4 ;;
    magenta) n=5 ;;
    cyan   ) n=6 ;;
    white  ) n=7 ;;
    grey   ) n=8 ;;
    *      ) n=$1;;
  esac
  # shellcheck disable=SC2059
  [ -n "$n" ] && printf "$fmt" "$(tput setaf "$n")"
  shift
  printf %s "$@"
  # shellcheck disable=SC2059
  [ -n "$n" ] && printf "$fmt" "$(tput sgr0)"
}

# Print a clickable terminal hyperlink: hyperlink <url> <text>
hyperlink() {
  # shellcheck disable=SC1003 # \e\\ below is a literal backslash escape, not an unterminated quote
  printf '\e]8;;%s\e\\%s\e]8;;\e\\' "$@"
}

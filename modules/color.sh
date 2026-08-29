color() {
  local n
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
  [ -n "$n" ] && printf '\x01%s\x02' "$(tput setaf "$n")"
  shift
  printf %s "$@"
  [ -n "$n" ] && printf '\x01%s\x02' "$(tput sgr0)"
}

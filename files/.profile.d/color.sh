color() {
  [ -n "$IS_COLOR" ] && case $1 in
    black  ) _color=0 ;;
    red    ) _color=1 ;;
    green  ) _color=2 ;;
    yellow ) _color=3 ;;
    blue   ) _color=4 ;;
    magenta) _color=5 ;;
    cyan   ) _color=6 ;;
    white  ) _color=7 ;;
    *      ) _color=$1;;
  esac
  [ -n "$_color" ] && printf '\x01%s\x02' "$(tput setaf "$_color")"
  shift
  printf %s "$@"
  [ -n "$_color" ] && printf '\x01%s\x02' "$(tput sgr0)"
  unset _color
}

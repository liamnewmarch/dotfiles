alias hidefile='xattr -w -x com.apple.FinderInfo "$(xattr -p -x com.apple.FinderInfo ~/Library)"'
alias showfile='xattr -d com.apple.FinderInfo 2> /dev/null'

hyperlink() {
  printf "\e]8;;%s\e\\%s\e]8;;\e\\" "$@"
}

alias dictionary='${EDITOR:-open} ~/Library/Spelling/LocalDictionary'
alias hidefile='SetFile -a V'
alias showfile='SetFile -a v'

hyperlink() {
  printf "\e]8;;%s\e\\%s\e]8;;\e\\" "$@"
}

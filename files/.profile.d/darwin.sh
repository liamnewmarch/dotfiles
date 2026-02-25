export BROWSER='open'

alias browse='$BROWSER'
alias dictionary='edit ~/Library/Spelling/LocalDictionary'
alias hidefile='chflags hidden'
alias showfile='chflags nohidden'

hyperlink() {
  printf "\e]8;;%s\e\\%s\e]8;;\e\\" "$@"
}

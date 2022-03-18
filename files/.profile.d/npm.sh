# Return early if npm is not defined
if ! command -v npm >/dev/null; then
  return
fi

alias n='npm'
alias ng='npm --global --no-audit'
alias ngi='npm --global --no-audit install'
alias ngu='npm --global --no-audit uninstall'
alias ngup='npm --global --no-audit update'
alias ni='npm install'
alias nin='npm init'
alias nid='npm install --save-dev'
alias nr='npm run'
alias nrb='npm rebuild'
alias ns='npm start'
alias nt='npm test'
alias nu='npm uninstall'
alias nud='npm uninstall --save-dev'
alias nup='npm update'

_npm_init_private_template='{
  "private": true,
  "type": "module"
}
'

npm() {
  case "$1" in
    init )
      printf 'Use quick private package template? [Y/n] '
      read -r yn
      case "$yn" in
        [Yy]* | '' )
          echo "$_npm_init_private_template" > package.json
          ;;
        * )
          command npm "$@"
          ;;
      esac
      ;;
    * )
      command npm "$@"
      ;;
  esac
  return $?
}

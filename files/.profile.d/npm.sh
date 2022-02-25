# Return early if npm is not defined
if ! command -v npm >/dev/null; then
  return
fi

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

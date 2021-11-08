# Oh my Zsh plugins
export plugins=(
    colored-man-pages
    docker
    docker-compose
    gcloud
    gitignore
    man
    node
    npm
    pep8
    pip
    python
    tmux
)

# Oh-my-Zsh platform setup
if [ -n "$IS_MACOS" ]; then
  plugins+=(brew macos)
elif [ -n "$(command -v lsb_release)" ]; then
  case "$(lsb_release -is)" in
    'Debian'|'Raspbian' )
      plugins+=(debian)
      ;;
    'Ubuntu' )
      plugins+=(ubuntu)
      ;;
  esac
fi

# Oh-my-Zsh specific variables
export HIST_STAMPS='yyyy-mm-dd'
export UPDATE_ZSH_DAYS=7
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME='liam'
export ZSH_TMUX_AUTOSTART='false'
export ZSH_TMUX_AUTOQUIT='false'

[ -r "$HOME/.profile" ] && . "$HOME/.profile"

[ -n "$IS_INTERACTIVE" ] && [ -r "$ZSH/oh-my-zsh.sh" ] && . "$ZSH/oh-my-zsh.sh"

# Reapply LS_COLORS
# shellcheck disable=SC2153
if [ -n "$IS_COLOR" ]; then
  export LSCOLORS='exfxcxdxbxegedabagacad'
  export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
fi

# Disable auto `cd`
unsetopt autocd

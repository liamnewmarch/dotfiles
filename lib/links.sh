# Shared registry of the files install.sh symlinks from home/ into $HOME.
# Sourced by install.sh, uninstall.sh and `dotfiles doctor` (modules/dotfiles.sh)
# so the three stay in sync automatically. Add a new linked file by editing
# only this file.
#
# No path listed here contains a space: dotfiles_link_paths() output is
# word-split deliberately by every caller.

# shellcheck disable=SC2034 # used by every file that sources this one
DOTFILES_LINK_GROUPS='bash git node screen tmux ghostty helix'

# Human-readable description of a group, used in install/uninstall prompts
dotfiles_link_label() {
  case "$1" in
    bash)    echo '.bash_profile, .bashrc, .inputrc and .profile' ;;
    git)     echo '.gitconfig and .gitignore' ;;
    node)    echo '.npmrc' ;;
    screen)  echo '.screenrc' ;;
    tmux)    echo '.tmux.conf and theme' ;;
    ghostty) echo '.config/ghostty/ files' ;;
    helix)   echo '.config/helix/ config files' ;;
  esac
}

# Space-separated list of paths in a group, relative to both home/ and $HOME
dotfiles_link_paths() {
  case "$1" in
    bash)    echo '.profile .inputrc .bash_profile .bashrc' ;;
    git)     echo '.gitconfig .gitignore' ;;
    node)    echo '.npmrc' ;;
    screen)  echo '.screenrc' ;;
    tmux)    echo '.tmux.conf .tmux/themes/llama.conf' ;;
    ghostty) echo '.config/ghostty/config .config/ghostty/themes/llama' ;;
    helix)   echo '.config/helix/config.toml .config/helix/languages.toml .config/helix/themes/llama.toml' ;;
  esac
}

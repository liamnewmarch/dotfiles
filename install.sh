#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:-"$(cd "$(dirname "$0")" || exit; pwd -P)"}"

# HELPER FUNCTIONS

# Prompt the user for confirmation
confirm() {
  local continue
  read -r -p "$1 [y/N] " continue
  case "$continue" in
    [yY][eE][sS]|[yY])
      true
      ;;
    *)
      false
      ;;
  esac
}

# Clone or pull a GitHub repo
github() {
  local dest
  dest="${2:-'.'}/$(echo "$1" | cut -d '/' -f2)"
  if [ -e "$dest" ]; then
    echo "A repository at path $dest already exists, updating..."
    git -C "$dest" pull || echo 'ERROR running command "git pull"'
  else
    git clone --depth 1 "https://github.com/$1.git" "$dest" || echo 'ERROR running command "git clone"'
  fi
}

# Test if the current system is macOS
is_macos() {
  [ "$(uname -s)" = 'Darwin' ]
}

# Create a symlink in the user's home dir
link() {
  ln -fs "$DOTFILES_DIR/files/$1" "$HOME/$2"
}

## INSTALLATION

# Install bash
if confirm 'Link .bash_profile, .bashrc, .inputrc and .profile?'; then
  echo '[1/3] Link ~/.profile and ~/.profile.d'
  link .profile
  [ ! -d "$HOME/.profile.d" ] && link .profile.d
  echo '[2/3] Link ~/.inputrc'
  link .inputrc
  echo '[3/3] Link ~/.bashrc and ~/.bash_profile'
  link .bash_profile
  link .bashrc
  echo 'Done'
fi

# Git
if confirm 'Link .gitconfig and .gitignore?'; then
  echo '[1/2] Linking gitconfig'
  link .gitconfig
  echo '[2/2] Linking gitignore'
  link .gitignore
  echo 'Done'
fi

# Tmux
if confirm 'Link .tmux.conf and install theme?'; then
  echo '[1/2] Installing tmux-themepack'
  github jimeh/tmux-themepack "$HOME/.tmux/themes"
  echo '[2/2] Linking file'
  link .tmux.conf
  echo 'Done'
fi

# Vim
if confirm '[Deprecated] Link .vimrc and install plugins?'; then
  plugins=(
    tpope/vim-sensible
    ctrlpvim/ctrlp.vim
    dense-analysis/ale
    airblade/vim-gitgutter
    junegunn/goyo.vim
    Yggdroot/indentLine
    tpope/vim-fugitive
    preservim/nerdtree
    editorconfig/editorconfig-vim
  )
  steps=$(( ${#plugins[@]} + 1 ))
  for index in "${!plugins[@]}"; do
    plugin="${plugins[$index]}"
    echo "[$(( index + 1 ))/${steps}] Install ${plugin}"
    github "$plugin" "$HOME/.vim/pack/custom/start"
  done
  echo "[${steps}/${steps}] Linking config file"
  link .vimrc
  unset index plugin plugins steps
fi

# Alacritty
if confirm 'Link .config/alacritty/ config?'; then
  echo '[1/1] Linking config'
  mkdir -p "$HOME/.config/alacritty"
  link .config/alacritty/alacritty.toml .config/alacritty
fi

# Helix
if confirm 'Link .config/helix/ config files?'; then
  echo '[1/1] Linking config files'
  mkdir -p "$HOME/.config/helix/themes"
  link .config/helix/config.toml .config/helix
  link .config/helix/languages.toml .config/helix
  link .config/helix/themes/panda.toml .config/helix/themes
fi

# Command-line Tools for Xcode
if is_macos && [ -z "$(xcode-select -p)" ] && confirm 'Install Xcode command line tools?'; then
  xcode-select --install
fi

# Homebrew
if is_macos && ! command -v brew >/dev/null && confirm 'Install Homebrew?'; then
  echo '[1/1] Installing Homebrew'
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'Done'
fi

# macOS defaults
if is_macos && confirm 'Write custom macOS defaults?'; then
  if confirm '[1/14] Expand save and print dialogs?'; then
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
  fi
  if confirm '[2/14] Disable downloaded application quarantine?'; then
    defaults write com.apple.LaunchServices LSQuarantine -bool false
  fi
  if confirm '[3/14] Disable smart text features?'; then
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
  fi
  if confirm '[4/14] Enable tap to click?'; then
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  fi
  if confirm '[5/14] Apply Finder defaults?'; then
    defaults write com.apple.finder DisableAllAnimations -bool true
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    defaults write com.apple.finder FXPreferredViewStyle -string "Clmv"
    killall Finder
  fi
  if confirm '[6/14] Apply defaults for new volumes?'; then
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
    defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
    defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
  fi
  if confirm '[7/14] Apply Dock defaults?'; then
    defaults write com.apple.dock tilesize -int 32
    defaults write com.apple.dock show-process-indicators -bool true
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -float 0
    killall Dock
  fi
  if confirm '[8/14] Enable checking for updates but prevent download?'; then
    defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
    defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
    defaults write com.apple.SoftwareUpdate AutomaticDownload -int 0
    defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 0
    defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 0
  fi
  if confirm '[9/14] Disable swipe navigation in Google Chrome?'; then
    defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
    defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
  fi
  if confirm '[10/14] Disable Spotlight items?'; then
    defaults write com.apple.spotlight orderedItems -array \
      '{"enabled" = 1;"name" = "APPLICATIONS";}' \
      '{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
      '{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
      '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
      '{"enabled" = 0;"name" = "BOOKMARKS";}' \
      '{"enabled" = 0;"name" = "CONTACT";}' \
      '{"enabled" = 0;"name" = "DIRECTORIES";}' \
      '{"enabled" = 0;"name" = "DOCUMENTS";}' \
      '{"enabled" = 0;"name" = "EVENT_TODO";}' \
      '{"enabled" = 0;"name" = "FONTS";}' \
      '{"enabled" = 0;"name" = "IMAGES";}' \
      '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
      '{"enabled" = 0;"name" = "MENU_OTHER";}' \
      '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}' \
      '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
      '{"enabled" = 0;"name" = "MESSAGES";}' \
      '{"enabled" = 0;"name" = "MOVIES";}' \
      '{"enabled" = 0;"name" = "MUSIC";}' \
      '{"enabled" = 0;"name" = "PDF";}' \
      '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
      '{"enabled" = 0;"name" = "SOURCE";}' \
      '{"enabled" = 0;"name" = "SPREADSHEETS";}'
    killall mds > /dev/null 2>&1
    sudo mdutil -i on / > /dev/null
    sudo mdutil -E / > /dev/null
  fi
  if confirm '[11/14] Disable boot sound?'; then
    sudo nvram SystemAudioVolume=' '
  fi
  if confirm '[12/14] Enable AAC and AptX bluetooth codecs?'; then
    sudo defaults write bluetoothaudiod 'Enable AptX codec' -bool true
    sudo defaults write bluetoothaudiod 'Enable AAC codec' -bool true
  fi
  if confirm '[13/14] Increase sleep timeout to 15 minutes?'; then
    sudo pmset -a displaysleep 15 sleep 15 powernap 0 lidwake 1
  fi
  if confirm '[14/14] Enable HiDPI resolutions?'; then
    sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true
  fi
  echo 'Done'
fi

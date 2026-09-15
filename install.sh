#!/usr/bin/env bash

# Usage: install.sh [-y|--yes]
#
# -y/--yes (or DOTFILES_ASSUME_YES=1) skips the confirmation prompts for
# linking dotfiles, so the installer can run non-interactively (e.g. piped
# in via docs/index.html, where stdin isn't a terminal). It deliberately does
# NOT extend to the Xcode/Homebrew installs or the macOS `defaults` writes
# below - those are always skipped unless a real interactive confirmation is
# given.

set -e

DOTFILES_DIR="${DOTFILES_DIR:-"$(cd "$(dirname "$0")" || exit; pwd -P)"}"

for _arg in "$@"; do
  case "$_arg" in
    -y|--yes) DOTFILES_ASSUME_YES=1 ;;
    *)
      echo "Usage: $0 [-y|--yes]" >&2
      exit 1
      ;;
  esac
done
unset _arg

# shellcheck source=lib/links.sh
. "$DOTFILES_DIR/lib/links.sh"
# shellcheck source=lib/confirm.sh
. "$DOTFILES_DIR/lib/confirm.sh"

# HELPER FUNCTIONS

# Test if the current system is macOS
is_macos() {
  [ "$(uname -s)" = 'Darwin' ]
}

# Create a symlink in the user's home dir, backing up anything already there
# that isn't already this exact symlink (a real file, a foreign symlink, or a
# broken one)
link() {
  local src="$DOTFILES_DIR/home/$1" dest="$HOME/$1" backup
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if ! { [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; }; then
      backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
      mv "$dest" "$backup"
      echo "  Backed up existing ~/$1 to $(basename "$backup")"
    fi
  fi
  ln -fs "$src" "$dest"
}

# Remove a symlink, but only if it points into this dotfiles repo (mirrors
# unlink_managed() in uninstall.sh)
unlink_stale() {
  local path="$HOME/$1"
  [ -L "$path" ] || return 0
  case "$(readlink "$path")" in
    "$DOTFILES_DIR"/*)
      rm "$path"
      echo "Removed stale ~/$1 symlink"
      ;;
  esac
}

## INSTALLATION

for _group in $DOTFILES_LINK_GROUPS; do
  if [ -n "$DOTFILES_ASSUME_YES" ] || confirm "Link $(dotfiles_link_label "$_group")?"; then
    for _path in $(dotfiles_link_paths "$_group"); do
      echo "Linking ~/$_path"
      link "$_path"
    done
    if [ "$_group" = bash ]; then
      # Moved out of the repo in favour of ~/.config/dotfiles/local.sh; migrate it
      # if it's still where an older install.sh left it
      _old_local="$DOTFILES_DIR/files/.profile.d/local.sh"
      if [ -f "$_old_local" ]; then
        mkdir -p "$HOME/.config/dotfiles"
        mv "$_old_local" "$HOME/.config/dotfiles/local.sh"
        echo 'Moved local.sh to ~/.config/dotfiles/local.sh'
      fi
      unset _old_local
      unlink_stale .profile.d
    fi
    echo 'Done'
  fi
done
unset _group _path

if [ -z "$DOTFILES_ASSUME_YES" ]; then
  # Command-line Tools for Xcode
  if is_macos && [ -z "$(xcode-select -p)" ] && confirm 'Install Xcode command line tools?'; then
    xcode-select --install
  fi

  # Homebrew
  if is_macos && ! command -v brew >/dev/null && confirm 'Install Homebrew?'; then
    echo '[1/1] Installing Homebrew'
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ -x /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
    echo 'Done'
  fi

  # Homebrew bundle
  if command -v brew >/dev/null && [ -e "$HOME/.Brewfile" ] &&
     confirm 'Install packages from ~/.Brewfile?'; then
    echo '[1/2] Running brew bundle install --global'
    brew bundle install --global ||
      echo "  Some packages failed; re-run 'brew bundle install --global'"
    # Not in the Brewfile: `npm` entries there can't pin a version, and
    # TypeScript 7.x breaks the Helix LSP setup
    echo '[2/2] Installing typescript@6'
    if command -v npm >/dev/null; then
      npm install --global typescript@6 || echo '  typescript@6 install failed'
    else
      echo '  Skipped: npm not found'
    fi
    echo 'Done'
  fi
fi

# macOS defaults
if [ -z "$DOTFILES_ASSUME_YES" ] && is_macos && confirm 'Write custom macOS defaults?'; then
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

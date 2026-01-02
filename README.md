# dotfiles

This repo contains my [dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory#Unix_and_Unix-like_environments).

See below for instructions to install, but basically running the `install.sh` script creates symlinks in your $HOME dir.

macOS and Debian are supported. On macOS the installer checks to see if Command-line Tools for Xcode and Homebrew are installed, and prompts to install them if not.

After running the install script, aliases, functions and $PATH extensions are organised by tool in ~/.profile.d/*.sh. You can create a ~/.profile.d/local.sh for machine-specific settings – an alias to edit this file and reload it is `localedit`.

## Supported tools

* Alacritty (terminal emulator)
* Helix (editor)
* Bash
* tmux
* APT, Homebrew

## Install with `git`

The easiest way to install is to clone this repo and run the `install.sh` script.

```sh
git clone https://github.com/liamnewmarch/dotfiles.git .dotfiles  # This can be any path
.dotfiles/install.sh
```

## Using the `curl` installer

*__Note:__* requires `bash`, `curl` and `git`.

You can also use the online install script which does the above in a more complicated way.

```sh
bash -c "$(curl -fsSL https://liamnewmarch.github.io/dotfiles)"
```

Changing the default install directory is supported via the `DOTFILES_DIR` env var

```sh
DOTFILES_DIR="$HOME/code/liamnewmarch/dotfiles"
bash -c "$(curl -fsSL https://liamnewmarch.github.io/dotfiles)"
```

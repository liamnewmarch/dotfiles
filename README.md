# Dotfiles

This repo contains my [dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory#Unix_and_Unix-like_environments) – config files for the command-line tools I use in my daily workflow.

I use bash shell on macOS and Debian. These are the only supported combinations for now. On macOS, the installer checks to see if Command-line Tools for Xcode and Homebrew are installed, and prompts to install them if not.

If you’re interested in trying this out, see the installation instructions below. Note that the `install.sh` script creates symlinks in your `$HOME` dir. This could lead to data loss, so __make sure to backup your files__ and maybe try it in fresh user/home directory first.


## What’s included

### Config files and themes

* Ghostty (terminal emulator)
* Helix (editor)
* Bash
* tmux
* Git

### Env vars

* `DOTFILES_DIR` – the dotfiles installation path.
* `IS_COLOR` – whether the current terminal supports colour.
* `IS_INTERACTIVE` – whether the shell is running interactively.
* `IS_LINUX` – whether the current platform is `'Linux'`.
* `IS_MACOS` – whether the current platform is `'Darwin'`.

### Aliases

* `edit` – edit files in the default `$EDITOR`.
* `localedit` – edit `~/.profile.d/local.sh` in the default `$EDITOR`.
* `mkcd` – create a directory and immediately `cd` into it. Supports nested directories, too.
* `serve` – start a HTTP server to serve files in the current directory.
* `temp` – create a directory in `/tmp` and start a shell in it.
* `hidefile` – (macOS) set attribute flags to hide a file from Finder.
* `showfile` – (macOS) remove attribute flags to hide a file from Finder.
* `sudoedit` – (macOS) edit files as root in the default `$EDITOR` with `sudo -e`.

There are also abbreviated aliases for some commands, e.g. `gst` is an alias for `git status`. These are provided for:

* Docker - see `~/.profile.d/docker.sh`.
* Git – see `~/.profile.d/git.sh`.
* npm – see `~/.profile.d/npm.sh`.

### Functions

* `color` – print a string in the specified color, e.g. `echo "$(color blue 'This text is blue')"`.
* `motd` – prints a Message Of The Day string for new shells. Note: this is similar but unrelated to `/etc/motd`.
* `update` – updates the local dotfiles repo, then update system packages through Homebrew or APT.

### Local modifications

Machine specific settings and overrides can go in `~/.profile.d/local.sh`. There’s an alias to edit this file in the default $EDITOR and immediately source it, `localedit`.

One recommended use for this file is to set a host nickname which is used by the `motd` function:

```sh
export HOST_NICKNAME='My machine'
```

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

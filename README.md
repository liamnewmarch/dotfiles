# Dotfiles

This repo contains my [dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory#Unix_and_Unix-like_environments) – config files for the command-line tools I use in my daily workflow.

I use bash shell on macOS and Debian. These are the only supported platform/shell combinations. On macOS, the installer can also optionally install Command-line Tools for Xcode and Homebrew if they're not already present.

The `install.sh` script creates symlinks in your `$HOME` directory, which could potentially overwrite existing files. __Make sure to backup your files first__ and consider testing in a fresh user directory.


## What’s included

### Config files and themes

* Ghostty (terminal emulator)
* Helix (editor)
* Bash
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

## Installation

Clone the repo to `~/.dotfiles` and run the installer:

```sh
git clone https://github.com/liamnewmarch/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

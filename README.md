# Dotfiles

This repo contains my [dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory#Unix_and_Unix-like_environments) – config files for the command-line tools I use in my daily workflow.

I use bash on macOS and Debian. These are the only supported platform/shell combinations. On macOS, the installer can also optionally install Command-line Tools for Xcode and Homebrew if they're not already present.

The `install.sh` script creates symlinks in your `$HOME` directory. If a file already exists where a symlink would go, it's backed up first (as `<file>.bak.<timestamp>`) rather than overwritten. Pass `-y`/`--yes` (or set `DOTFILES_ASSUME_YES=1`) to skip the confirmation prompts and link everything non-interactively; this doesn't extend to the Xcode/Homebrew installs or the macOS `defaults` writes below, which always require an interactive confirmation.

## What’s included

### Config files and themes

* Ghostty (terminal emulator)
* Helix (editor)
* Bash
* Git
* Node (fnm and npm)
* Tmux
* Screen

### The `dotfiles` command

* `dotfiles edit` (alias `dfe`) – open the dotfiles repo in `$EDITOR`. Changes are sourced automatically.
* `dotfiles edit [file]` (alias `dfe [file]`) – open a specific `modules/[file].sh` in `$EDITOR`. Changes are sourced automatically.
* `dotfiles edit local` (alias `dfl`) – open `~/.config/dotfiles/local.sh` in `$EDITOR`. Changes are sourced automatically.
* `dotfiles reload` – re-source `~/.profile` in the current shell.
* `dotfiles restart` (alias `dotfiles reset`) – start a fresh login shell, replacing the current one.
* `dotfiles update` – pull the latest changes from git.
* `dotfiles path` – print the path to the dotfiles repo.
* `dotfiles doctor` – verify symlinks, repo state, and expected tools. Exits non-zero if anything looks wrong.

### Env vars

* `IS_COLOR` – whether the current terminal supports colour.
* `IS_INTERACTIVE` – whether the shell is running interactively.
* `IS_LINUX` – whether the current platform is `'Linux'`.
* `IS_MACOS` – whether the current platform is `'Darwin'`.

### Aliases

* `edit` – edit files in the default `$EDITOR`.
* `browse` – open a URL in the default `$BROWSER` (`open` on macOS, `xdg-open` on Linux, if installed).
* `ghosttyedit` (alias `ge`) – edit `~/.config/ghostty/` in the default `$EDITOR`.
* `helixedit` (alias `he`) – edit `~/.config/helix/` in the default `$EDITOR`.
* `mkcd` – create a directory and immediately `cd` into it. Supports nested directories, too.
* `serve` – start an HTTP server to serve files in the current directory.
* `temp` – create a directory in `/tmp` and start a shell in it.
* `hidefile` – (macOS) set attribute flags to hide a file from Finder.
* `showfile` – (macOS) remove attribute flags to hide a file from Finder.
* `sudoedit` – (macOS) edit files as root in the default `$EDITOR` with `sudo -e`.

Abbreviated aliases are also provided for some commands:

* Docker – see `dotfiles edit docker`.
* Dotfiles – see `dotfiles edit dotfiles`.
* Git – see `dotfiles edit git`.
* Node/npm – see `dotfiles edit node`.

### Functions

* `color` – print a string in the specified color, e.g. `echo "$(color blue 'This text is blue')"`.
* `hyperlink` – print a clickable terminal hyperlink, e.g. `hyperlink 'https://example.com' 'Example'`.
* `motd` – prints a Message Of The Day string for new shells. Note: this is similar but unrelated to `/etc/motd`.
* `update` (alias `up`) – updates the local dotfiles repo, then updates system packages through Homebrew or APT.

### Local modifications

Machine-specific settings and overrides can go in `~/.config/dotfiles/local.sh`. Use `dfl` to edit this file in the default `$EDITOR` and immediately source it.

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

Or, to clone (or update an existing clone) and install in one step:

```sh
curl -fsSL https://liamnewmarch.github.io/dotfiles/ | bash
```

## Uninstallation

To remove the symlinks `install.sh` created, run `~/.dotfiles/uninstall.sh`. It only removes symlinks that point into the dotfiles repo, and does not revert macOS defaults or uninstall Homebrew.

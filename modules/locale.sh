# Force a UTF-8 locale when the environment doesn't already provide one.

if [ "$(locale charmap 2>/dev/null)" != 'UTF-8' ]; then
  # Clear these first: a forwarded LC_CTYPE=C outranks LANG under both libc and tmux.
  unset LC_ALL LC_CTYPE
  export LANG='en_GB.UTF-8'
  # An unavailable locale fails silently, so verify rather than assume. C.UTF-8
  # is always present on both macOS and Debian.
  [ "$(locale charmap 2>/dev/null)" = 'UTF-8' ] || export LANG='C.UTF-8'
fi

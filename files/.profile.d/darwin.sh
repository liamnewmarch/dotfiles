alias chrome='open -a "Google Chrome"'
alias hidefile='xattr -w -x com.apple.FinderInfo "$(xattr -p -x com.apple.FinderInfo ~/Library)"'
alias showfile='xattr -d com.apple.FinderInfo 2> /dev/null'

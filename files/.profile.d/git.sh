# Add
alias g='git'
alias ga='git add'
alias gaa='git add --all'

# Branch
alias gb='git branch'
alias gba='git branch -a'

# Commit
alias gc='git commit -v'
alias gc!='git commit -v --amend --no-edit'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend --no-edit'

# Checkout
alias gcb='git checkout -b'
alias gco='git checkout'
alias gcm='git checkout $(git symbolic-ref refs/remotes/origin/HEAD | awk -F "/" "{print \$NF}")'

# Clone
alias gcl='git clone --recurse-submodules'

# Diff
alias gd='git diff'
alias gda='git diff -- ":(exclude)package-lock.json"'
alias gdw='git diff --word-diff'

# Fetch
alias gf='git fetch'

# Pull
alias gl='git pull'

# Log
alias gls='git log --stat'
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias glog='git log --oneline --decorate --graph'
alias gt='glol --since=12pm'
alias gy='glol --since=yesterday.12pm --until=12pm'

# Merge
alias gm='git merge'
alias gma='git merge --abort'

# Push
alias gp='git push'
alias gpuo='git push -u origin $(git rev-parse --abbrev-ref HEAD)'

# Rebase
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbs='git rebase --skip'
alias grbm='git rebase $(git symbolic-ref refs/remotes/origin/HEAD | awk -F "/" "{print \$NF}")'

# Remove
alias grm='git rm'
alias grmc='git rm --cached'

# Reset
alias grs='git reset'

# Restore
alias grss='git restore --staged'
alias grsw='git restore --worktree'

# Show
alias gsh='git show'

# Stash
alias gsta='git stash push'
alias gstd='git stash drop'
alias gstp='git stash pop'
alias gsts='git stash show --text'

# Status
alias gst='git status'
alias gsti='git status --ignored'

# Switch
alias gsw='git switch'
alias gswc='git switch --create'
alias gswm='git switch $(git symbolic-ref refs/remotes/origin/HEAD | awk -F "/" "{print \$NF}")'

github() {
  gcl git@github.com:"${1}.git"
}

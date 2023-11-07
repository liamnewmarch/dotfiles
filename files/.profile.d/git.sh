# Return early if git is not defined
if ! command -v git >/dev/null; then
  return
fi

_git_default_branch() {
  git symbolic-ref refs/remotes/origin/HEAD | cut -d / -f 4-
}

# Add
alias g='git'
alias ga='git add'
alias gaa='git add --all'

# Branch
alias gb='git branch'
alias gba='git branch --all'
alias gbd='_git_default_branch'

# Commit
alias gc='git commit --verbose'
alias gc!='git commit --amend --no-edit --verbose'
alias gca='git commit --all --verbose'
alias gca!='git commit --all --amend --no-edit --verbose'

# Clone
alias gcl='git clone --recurse-submodules'

# Diff
alias gd='git diff -- ":(exclude)package-lock.json"'
alias gda='git diff'
alias gds='git diff --stat'
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
alias gm='git merge --no-ff'
alias gma='git merge --abort'
alias gmf='git merge --ff'

# Push
alias gp='git push'
alias gp='git push --force-with-lease'
alias gpuo='git push -u origin $(git rev-parse --abbrev-ref HEAD)'

# Rebase
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grbs='git rebase --skip'
alias grbm='git rebase "$(_git_default_branch)"'

# Remove
alias grm='git rm'
alias grmc='git rm --cached'

# Reset
alias grs='git reset'

# Restore
alias grsa='git restore --staged --worktree'
alias grss='git restore --staged'
alias grsw='git restore --worktree'

# Show
alias gsh='git show'
alias gshs='git show --stat'

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
alias gswm='git switch "$(_git_default_branch)"'

github() {
  gcl git@github.com:"${1}.git"
}

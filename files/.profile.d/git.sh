# Return early if git is not defined
if ! command -v git >/dev/null; then
  return
fi

if ! command -v __git_complete >/dev/null; then
  __git_complete() {
    :
  }
fi

_git_default_branch() {
  git symbolic-ref refs/remotes/origin/HEAD | cut -d / -f 4-
}

alias g='git'

# Add
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --all --patch'
__git_complete g git
__git_complete ga git_add
__git_complete gaa git_add
__git_complete gap git_add

# Branch
alias gb='git branch'
alias gba='git branch --all'
alias gbd='_git_default_branch'
__git_complete gb git_branch
__git_complete gba git_branch

# Commit
alias gc='git commit --verbose'
alias gc!='git commit --amend --no-edit --verbose'
alias gca='git commit --all --verbose'
alias gca!='git commit --all --amend --no-edit --verbose'
__git_complete gc git_commit
__git_complete gc! git_commit
__git_complete gca git_commit
__git_complete gca! git_commit

# Clone
alias gcl='git clone --recurse-submodules'
__git_complete gcl git_clone

# Diff
alias gd='git diff -- ":!*lock.*" ":!*.lock*"'
alias gda='git diff'
alias gds='git diff --stat'
alias gdw='git diff --word-diff'
__git_complete gd git_diff
__git_complete gda git_diff
__git_complete gds git_diff
__git_complete gdw git_diff

# Fetch
alias gf='git fetch'
__git_complete gf git_fetch

# Pull
alias gl='git pull'
__git_complete gl git_pull

# Log
alias gls='git log --stat'
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias glog='git log --oneline --decorate --graph'
alias gt='glol --since=12pm'
alias gy='glol --since=yesterday.12pm --until=12pm'
__git_complete gls git_log
__git_complete glo git_log
__git_complete glol git_log
__git_complete glog git_log
__git_complete gt git_log
__git_complete gy git_log

# Merge
alias gm='git merge --no-ff'
alias gma='git merge --abort'
alias gmf='git merge --ff'
__git_complete gm git_merge
__git_complete gma git_merge
__git_complete gmf git_merge

# Push
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpuo='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
__git_complete gp git_push
__git_complete gpf git_push
__git_complete gpuo git_push

# Rebase
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grbs='git rebase --skip'
alias grbm='git rebase "$(_git_default_branch)"'
__git_complete grb git_rebase
__git_complete grba git_rebase
__git_complete grbc git_rebase
__git_complete grbi git_rebase
__git_complete grbs git_rebase
__git_complete grbm git_rebase

# Remove
alias grm='git rm'
alias grmc='git rm --cached'
__git_complete grm git_rm
__git_complete grm git_rm

# Reset
alias grs='git reset'
__git_complete grs git_reset

# Restore
alias grsa='git restore --staged --worktree'
alias grss='git restore --staged'
alias grsw='git restore --worktree'
__git_complete grsa git_restore
__git_complete grss git_restore
__git_complete grsw git_restore

# Show
alias gsh='git show'
alias gshs='git show --stat'
__git_complete gsh git_show
__git_complete gshs git_show

# Stash
alias gsta='git stash push'
alias gstd='git stash drop'
alias gstp='git stash pop'
alias gsts='git stash show --text'
__git_complete gsta git_stash
__git_complete gstd git_stash
__git_complete gstp git_stash
__git_complete gsts git_stash

# Status
alias gst='git status'
alias gsti='git status --ignored'
__git_complete gst git_status
__git_complete gsti git_status

# Switch
alias gsw='git switch'
alias gswc='git switch --create'
alias gswm='git switch "$(_git_default_branch)"'
__git_complete gsw git_switch
__git_complete gswc git_switch
__git_complete gswm git_switch

github() {
  gcl git@github.com:"$1.git"
  cd "$(basename "$1")"
}

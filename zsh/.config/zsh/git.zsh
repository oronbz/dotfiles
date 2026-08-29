git_current_branch() {
  git symbolic-ref --short -q HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null
}

alias gst='git status'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcam='git commit --all --message'
alias gcmsg='git commit --message'
alias gd='git diff'
alias gaa='git add --all'
alias gl='git pull'
alias gp='git push'
alias gfo='git fetch origin'
alias glog='git log --oneline --decorate --graph'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias ggpush='git push origin "$(git_current_branch)"'
alias ggpull='git pull origin "$(git_current_branch)"'
alias gpsup='git push --set-upstream origin $(git_current_branch)'

alias gfom="git fetch origin master:master"
alias gcom="gco master"
alias gwl="git worktree list"
alias gwa="git worktree add"
alias gwr="git worktree remove"
alias pr="gh pr create --fill"
alias prd="gh pr create --fill --draft"
alias gg="git-good-game"

git-good-game() {
  if [ -z "$1" ]; then
    echo "Please provide a commit message"
    return 1
  fi
  git add .
  gcam "$1"
  ggpush
}

prune() {
  git fetch -p ; git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -D
}

stale() {
  git fetch -p
  git branch -vv | grep ': gone]' | awk '{print $1}'
}

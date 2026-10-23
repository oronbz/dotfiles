alias gfom='git fetch origin $(git_main_branch):$(git_main_branch)'
alias gfomd='git fetch origin && git switch --detach origin/$(git_main_branch)'
alias gcom='gco $(git_main_branch)'
alias gwl="git worktree list"
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


gwa() {
  local -a opt_b; zparseopts -D -E b:=opt_b
  [ -z "$1" ] && { echo "usage: gwa [-b <branch>] <branch|slug> [base=main/master]"; return 1; }
  local branch="${opt_b[2]:-$1}" slug="${1##*/}"
  local root; root=$(git rev-parse --path-format=absolute --git-common-dir) || return 1; root=${root%/.git}
  local dir="$root/.worktrees/$slug"
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git worktree add "$dir" "$branch"
  else
    git worktree add -b "$branch" "$dir" "${2:-$(git_main_branch)}"
  fi || return 1
  echo "$dir"
  command -v zoxide >/dev/null && zoxide add "$dir"
  if [ "${HERDR_ENV:-}" = 1 ]; then
    herdr worktree open --cwd "$root" --path "$dir" --label "$slug" --focus >/dev/null 2>&1
  else
    cd "$dir"
  fi
}

gwr() {
  [ -z "$1" ] && { echo "usage: gwr <slug|branch|path> [--force]"; return 1; }
  local root; root=$(git rev-parse --path-format=absolute --git-common-dir) || return 1; root=${root%/.git}
  local target="$1"; shift
  local dir
  if [ -d "$target" ]; then dir=$(cd "$target" && pwd)
  elif [ -d "$root/.worktrees/$target" ]; then dir="$root/.worktrees/$target"
  else dir=$(git worktree list --porcelain | awk -v b="refs/heads/$target" '/^worktree /{w=$2} $1=="branch" && $2==b {print w}')
  fi
  [ -z "$dir" ] && { echo "no worktree for '$target'"; return 1; }
  if [ "${HERDR_ENV:-}" = 1 ]; then
    herdr workspace list 2>/dev/null | jq -r --arg p "$dir" '.result.workspaces[] | select(.worktree.checkout_path==$p) | .workspace_id' \
      | while read -r ws; do herdr workspace close "$ws" >/dev/null 2>&1; done
  fi
  git worktree remove "$@" "$dir" || return 1
  command -v zoxide >/dev/null && zoxide remove "$dir" 2>/dev/null
  _gw_rm ${(f)"$(_gw_junk "$dir")"}
  echo "removed $dir"
}

gwsweep() {
  local -a junk; junk=(${(f)"$(_gw_junk)"})
  [[ $1 == -n ]] && { print -l $junk; return; }
  _gw_rm $junk || echo "nothing to sweep"
}

_gw_junk() {
  local dir=$1 d p
  for d in ~/Library/Developer/Xcode/DerivedData/*(N/); do
    [[ ${d:t} =~ '-[a-z]{28}$' ]] || continue
    p=$(/usr/libexec/PlistBuddy -c 'Print :WorkspacePath' "$d/info.plist" 2>/dev/null)
    if [[ -n $dir ]]; then [[ $p == $dir/* ]]; else [[ -z $p || ! -e $p ]]; fi && print -r -- "$d"
  done
  if [[ -n $dir ]]; then
    for d in ~/Library/Caches/xcode-build-server/${dir//\//-}(N) ~/.claude/projects/${dir//[^A-Za-z0-9]/-}(N); do print -r -- "$d"; done
  else
    for d in ~/Library/Caches/xcode-build-server/*(N/); do _gw_alive ${d:t} '/' || print -r -- "$d"; done
    for d in ~/.claude/projects/*(N/); do _gw_alive ${d:t} '[^A-Za-z0-9]' || print -r -- "$d"; done
  fi
}

# Cache keys flatten a path into dashes, so walk the filesystem to see if any real path flattens to the key.
_gw_alive() {
  local key=$1 base=$3 e s
  for e in "$base"/*(ND); do
    s=-${${e:t}//$~2/-}
    [[ $key == "$s" ]] && return 0
    [[ -d $e && $key == ${(b)s}-* ]] && _gw_alive "${key:${#s}}" "$2" "$e" && return 0
  done
  return 1
}

_gw_rm() {
  (( $# )) || return 1
  print -l "purging:" "$@"; rm -rf "$@" &!
}

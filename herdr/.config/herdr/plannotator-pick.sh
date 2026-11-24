#!/bin/zsh
PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
herdr="${HERDR_BIN_PATH:-herdr}"

pane="" agent=""
if [[ ${HERDR_ENV:-} == 1 ]]; then
  IFS=$'\t' read -r pane cwd agent < <("$herdr" pane list | jq -r '.result.panes[] | select(.focused) | [.pane_id, (.foreground_cwd // .cwd), (.agent // "")] | @tsv' | head -1)
  [[ -n $cwd ]] && cd "$cwd"
fi

fail() { print -r -- "$1"; print -n "Press any key to close."; read -sk1; exit 1 }

git rev-parse --git-dir >/dev/null 2>&1 || fail "$PWD is not a git repository."
base=$(git symbolic-ref -q --short refs/remotes/origin/HEAD || print master)

preview='case {1} in
  uncommitted) git -c color.ui=always status --short; echo; git -c color.ui=always diff --stat HEAD ;;
  staged) git -c color.ui=always diff --cached --stat ;;
  base) git -c color.ui=always log --oneline '$base'..HEAD; echo; git -c color.ui=always diff --stat '$base'...HEAD ;;
  *) git -c color.ui=always show --stat --format="%C(yellow)%h%C(reset) %s%n%an · %cr%n" {1} ;;
esac'

choice=$({
  print -r -- $'uncommitted\t\e[33m·\e[0m Uncommitted changes'
  print -r -- $'staged\t\e[33m·\e[0m Staged changes'
  print -r -- $'base\t\e[33m·\e[0m Everything since '"$base"
  git log -50 --color=always --format=$'%h\t%C(yellow)%h%C(reset) %s %C(dim)· %an · %cr%C(reset)'
} | fzf --ansi --delimiter=$'\t' --with-nth=2 --no-sort --layout=reverse --prompt='review › ' \
      --preview="$preview" --preview-window=right,50%) || exit 0

case ${choice%%$'\t'*} in
  uncommitted) args=() ;;
  staged) args=(--staged) ;;
  base) args=(--base "$base") ;;
  *) args=(--commit "${choice%%$'\t'*}") ;;
esac

if [[ -n $pane ]]; then
  [[ -n $agent ]] && args+=(--deliver-to "$pane")
  plannotator-tui herdr review "${args[@]}" || fail "plannotator-tui could not open that review."
else
  exec plannotator-tui review "${args[@]}"
fi

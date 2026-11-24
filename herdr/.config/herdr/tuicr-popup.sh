#!/bin/sh
PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
herdr="${HERDR_BIN_PATH:-herdr}"
cwd=$("$herdr" pane list | jq -r '.result.panes[] | select(.focused) | .foreground_cwd // .cwd' | head -1)
cd "${cwd:-$HOME}" || exit 1
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  printf 'tuicr: %s is not a git repository. Press Enter to close.' "$PWD"
  read -r _
  exit 1
fi
exec tuicr

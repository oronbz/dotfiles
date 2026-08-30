#!/bin/sh
PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
herdr="${HERDR_BIN_PATH:-herdr}"
pane="${1:-$("$herdr" pane list | jq -r '.result.panes[] | select(.focused) | .pane_id')}"
pid=$("$herdr" pane process-info --pane "$pane" | jq -r '.result.process_info.shell_pid')
tty=$(ps -o tty= -p "$pid" | tr -d ' ')
[ -n "$tty" ] && [ "$tty" != "??" ] || exit 1
printf '\033[H\033[2J\033[3J' > "/dev/$tty"
"$herdr" pane send-keys "$pane" ctrl+l

#!/usr/bin/env bash
set -euo pipefail

target=$(
  herdr agent list \
    | jq -r '.result.agents[]
        | [.pane_id, .agent, .agent_status, (.cwd | split("/") | last), .terminal_title_stripped]
        | @tsv' \
    | column -t -s $'\t' \
    | fzf --prompt='agent> ' --height=100% --reverse --no-multi \
    | awk '{print $1}'
)

[ -n "$target" ] && herdr agent focus "$target"

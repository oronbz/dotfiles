xc() { xed . }
derived() { rm -rfv ~/Library/Developer/Xcode/DerivedData | pv -l -i 0.2 -N "deleted" > /dev/null }
pi() { bundle exec pod install }
cpreviews() { xcrun simctl --set previews delete all }
simstream() {
  local udid=${1:-booted} fmt=${2:-kitty} dir
  if [[ $udid != booted && ! $udid =~ '^[0-9A-Fa-f]{8}-' ]]; then
    udid=$(xcrun simctl list devices booted -j | jq -r --arg n "$1" '[.devices[][] | select(.name == $n)][0].udid // empty')
    [[ -n $udid ]] || { echo "no booted simulator named '$1'" >&2; return 1 }
  fi
  dir=$(mktemp -d)
  trap 'return' INT
  local tty=$(stty -g)
  trap "[[ $fmt == kitty ]] && printf '\e_Ga=d,d=A\e\\\\'; clear; tput cnorm; stty $tty; rm -rf ${(q)dir}" EXIT
  # Canonical mode buffers keys until Enter, so the per-frame read would never see a lone q.
  stty -icanon -echo
  tput civis; clear
  local key
  while xcrun simctl io $udid screenshot --mask=black $dir/s.png >/dev/null 2>&1; do
    printf '\e[H'
    chafa -f $fmt --size=${COLUMNS}x$((LINES - 1)) $dir/s.png
    read -rsk1 -u0 -t 0 key && [[ $key == [qQ] ]] && break
  done
}
fixschemes() {
  local f suppressed
  find . \( -path "*/DerivedData/*" -o -path "*/Build/*" -o -path "*/.build/*" \) -prune -o -name xcschememanagement.plist -print | while read -r f; do
    suppressed=$(plutil -extract SuppressBuildableAutocreation raw "$f" 2>/dev/null) || continue
    plutil -remove SuppressBuildableAutocreation "$f" && echo "unsuppressed in $f: ${suppressed//$'\n'/, }"
  done
  echo "done — restart Xcode to regenerate schemes"
}
code() { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* }

kill_audio() { sudo kill -9 $(ps -ax | grep coreaudiod | grep -v grep | awk '{print $1}') }

dawdl() { sudo ifconfig awdl0 down }
eawdl() { sudo ifconfig awdl0 up }

nvimclean() {
  rm -rf ~/.local/state/nvim
  rm -rf ~/.local/share/nvim
}

brewnew() {
  comm -13 <(grep -hEo '^(tap|brew|cask) "[^"]+"' ~/.dotfiles/Brewfile* | sort -u) \
    <(brew bundle dump --file=- 2>/dev/null | grep -Eo '^(tap|brew|cask) "[^"]+"' | sort -u)
}

cheat() { awk '/^## Cheat sheet/{p=1;next} /^## /{p=0} p' ~/.dotfiles/README.md | glow -s tokyo-night -w $((COLUMNS < 110 ? COLUMNS : 110)) - }

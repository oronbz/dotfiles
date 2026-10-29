xc() { xed . }
derived() { rm -rfv ~/Library/Developer/Xcode/DerivedData | pv -l -i 0.2 -N "deleted" > /dev/null }
pi() { bundle exec pod install }
cpreviews() { xcrun simctl --set previews delete all }
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

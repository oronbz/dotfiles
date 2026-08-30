xc() { xed . }
derived() { rm -rfv ~/Library/Developer/Xcode/DerivedData | pv -l -i 0.2 -N "deleted" > /dev/null }
pi() { bundle exec pod install }
godev() { cd "$HOME/go/src/github.com/oronbz" }
cpreviews() { xcrun simctl --set previews delete all }
swiftpm() { rm -rf ./Rider/.swiftpm }
gim() { gemini }
ghc() { zed ~/Library/Application\ Support/com.mitchellh.ghostty/config }
code() { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* }

reset_audio() {
  sudo kextunload /System/Library/Extensions/AppleHDA.kext
  sudo kextload /System/Library/Extensions/AppleHDA.kext
}
kill_audio() { sudo kill -9 $(ps -ax | grep coreaudiod | grep -v grep | awk '{print $1}') }

dawdl() { sudo ifconfig awdl0 down }
eawdl() { sudo ifconfig awdl0 up }

nvimclean() {
  rm -rf ~/.local/state/nvim
  rm -rf ~/.local/share/nvim
}

pfd() {
  osascript 2>/dev/null <<'APPLESCRIPT'
    tell application "Finder"
      return POSIX path of (insertion location as alias)
    end tell
APPLESCRIPT
}
cdf() { cd "$(pfd)" }
ofd() { open -a Finder "${1:-.}" }

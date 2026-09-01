export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="nvim"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home/"
export GOPATH="$HOME/go"
export HOMEBREW_BUNDLE_DUMP_NO_MAS=1
export HOMEBREW_BUNDLE_DUMP_NO_GO=1
export BUN_INSTALL="$HOME/.bun"

typeset -U path
path=(
  "$HOME/.local/bin"
  "$BUN_INSTALL/bin"
  /opt/homebrew/opt/ruby/bin
  /opt/homebrew/bin
  $path
  "$ANDROID_HOME/platform-tools"
  "$GOPATH/bin"
)

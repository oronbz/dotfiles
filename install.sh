#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

command -v brew >/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file=Brewfile

mkdir -p ~/.config/zsh
[ -f ~/.config/zsh/secrets.zsh ] || { cp zsh/.config/zsh/secrets.zsh.example ~/.config/zsh/secrets.zsh; chmod 600 ~/.config/zsh/secrets.zsh; }

chmod g-w /opt/homebrew/share
for pkg in */; do
  stow --no-folding --restow --target="$HOME" "${pkg%/}"
done
[ -d ~/.oh-my-zsh ] || git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
rm -f ~/.zcompdump* ~/.oh-my-zsh/cache/.zcompdump*
./herdr-plugins.sh
echo "done — open a new shell"

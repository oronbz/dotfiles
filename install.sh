#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

groups=(ios personal)
selected=" "
for arg in "$@"; do
  case $arg in
    --all) selected=" ${groups[*]} " ;;
    --ios | --personal) selected+="${arg#--} " ;;
    *) echo "usage: $0 [--ios] [--personal] [--all]" >&2; exit 1 ;;
  esac
done

wants() {
  [[ $selected == *" $1 "* ]] && return 0
  [ -t 0 ] || return 1
  local names answer
  names=$(grep -Eo '^(brew|cask) "[^"]+"' "Brewfile.$1" | sed -E 's#.*"(.*/)?([^/"]+)"#\2#' | tr '\n' ' ')
  read -rp "install $1 extras (${names% })? [y/N] " answer
  [[ $answer == [yY]* ]]
}
chosen=(Brewfile)
for group in "${groups[@]}"; do
  if wants "$group"; then chosen+=("Brewfile.$group"); fi
done

command -v brew >/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
bundle() { brew bundle --file="$1" || echo "warning: some $1 entries failed (see above), continuing" >&2; }
for f in "${chosen[@]}"; do bundle "$f"; done

mkdir -p ~/.config/zsh
[ -f ~/.config/zsh/secrets.zsh ] || { cp zsh/.config/zsh/secrets.zsh.example ~/.config/zsh/secrets.zsh; chmod 600 ~/.config/zsh/secrets.zsh; }

if [ ! -f ~/.gitconfig.local ]; then
  name=$(git config --global user.name || true)
  email=$(git config --global user.email || true)
  [ -n "$name" ] || read -rp "git user.name: " name
  [ -n "$email" ] || read -rp "git user.email: " email
  printf '[user]\n\tname = %s\n\temail = %s\n' "$name" "$email" > ~/.gitconfig.local
fi

packages=()
for pkg in */; do
  pkg=${pkg%/}
  [ "$pkg" = docs ] || packages+=("$pkg")
done

backup=~/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)
for pkg in "${packages[@]}"; do
  while IFS= read -r -d '' f; do
    rel=${f#"$pkg"/}
    target=~/$rel
    [ -e "$target" ] || [ -L "$target" ] || continue
    [ "$(realpath "$target" 2>/dev/null || true)" = "$(realpath "$f")" ] && continue
    mkdir -p "$backup/$(dirname "$rel")"
    mv "$target" "$backup/$rel"
  done < <(find "$pkg" -type f -print0)
done
if [ -d "$backup" ]; then
  echo "existing files moved to $backup"
  echo "merge what you still need into ~/.config/zsh/work.zsh (shell) or ~/.gitconfig.local (git)"
fi

command -v stow >/dev/null || brew install stow
for pkg in "${packages[@]}"; do
  stow --no-folding --restow --target="$HOME" "$pkg"
done
[ -d ~/.oh-my-zsh ] || git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
rm -f ~/.zcompdump* ~/.oh-my-zsh/cache/.zcompdump*
./herdr-plugins.sh
echo "done — open a new shell"

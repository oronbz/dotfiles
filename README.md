# dotfiles

macOS terminal setup. Managed with [GNU Stow](https://www.gnu.org/software/stow/): each top-level directory is a package whose layout mirrors `$HOME`, stowed as per-file symlinks (`--no-folding`).

## Stack

| | |
|---|---|
| terminal | [ghostty](https://ghostty.org) + [herdr](https://github.com/herdr) |
| shell | zsh, no framework — `zsh/.zshrc` + `zsh/.config/zsh/*.zsh` |
| prompt | [starship](https://starship.rs) (`pastel-powerline` base, trimmed) |
| plugins | zsh-autosuggestions · zsh-syntax-highlighting · zsh-completions · zsh-history-substring-search (brew) |
| tools | fzf · zoxide · eza · bat · lazygit · btop · k9s · yazi |
| editor | nvim — LazyVim (default, `nvim`/`lazy`), NvChad (`chad`), AstroNvim (`astro`) · zed |

## Install

```sh
git clone git@github.com:oronbz/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

Installs Homebrew + `Brewfile`, creates `~/.config/zsh/secrets.zsh` from the example (fill it in), stows every package.

## Layout

```
zsh/        .zshrc .zprofile .config/zsh/{path,aliases,git,functions}.zsh
starship/   .config/starship.toml
ghostty/    .config/ghostty/config
herdr/      .config/herdr/config.toml
git/        .gitconfig .config/git/ignore
nvim/       .config/{LazyVim,NvChad,AstroNvim}
lazygit/ zed/
Brewfile    brew bundle dump (taps, formulae, casks)
```

## Day to day

- Edit files in `~/.dotfiles` directly — they're symlinked, changes are live.
- New config: `mkdir -p ~/.dotfiles/<pkg>/.config/<pkg>`, move the file in, `cd ~/.dotfiles && stow --no-folding <pkg>`.
- After `brew install`: `brew bundle dump --force --file=~/.dotfiles/Brewfile`.
- Secrets live in `~/.config/zsh/secrets.zsh`, work-machine env/functions in `~/.config/zsh/work.zsh`; both gitignored, never in this repo.

## zsh notes

- Startup ~120ms. Profile: prepend `zmodload zsh/zprof` to `.zshrc`, run `zprof`.
- `compinit` uses the cached `~/.zcompdump` unless it's >24h old. New tool completion missing? `rm ~/.zcompdump`.
- Keys: `Ctrl+Space`/`→` accept suggestion · `↑`/`↓` substring history · `Ctrl+R` atuin history · `Ctrl+T` fzf files · `Alt+C` fzf cd · `z`/`zi` zoxide.

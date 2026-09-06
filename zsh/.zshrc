ZDOTCONF="$HOME/.config/zsh"

fpath=("$ZDOTCONF/completions" /opt/homebrew/share/zsh-completions /opt/homebrew/share/zsh/site-functions $fpath)
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git macos)
DISABLE_AUTO_TITLE="true"
zstyle ':omz:update' mode disabled
source "$ZSH/oh-my-zsh.sh"

for f in path secrets work aliases git functions; do
  [[ -r "$ZDOTCONF/$f.zsh" ]] && source "$ZDOTCONF/$f.zsh"
done

HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_all_dups pushd_silent no_beep

bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}%B%d%b%f'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border --info=inline"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:300 {}'"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"
export FZF_ALT_C_OPTS="--preview 'eza --icons --color=always --tree --level=2 {}'"
cached_init() {
  local f="$HOME/.cache/zsh/$1.zsh"
  [[ -s "$f" && "$f" -nt "${commands[$1]}" ]] || { mkdir -p "$HOME/.cache/zsh"; "${@:2}" > "$f"; }
  source "$f"
}
cached_init fzf fzf --zsh
cached_init zoxide zoxide init zsh
cached_init mise mise activate zsh --shims
cached_init atuin atuin init zsh --disable-up-arrow

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
[[ -f "$HOME/Desktop/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/Desktop/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/Desktop/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/Desktop/google-cloud-sdk/completion.zsh.inc"

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^ ' autosuggest-accept

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=''
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=''
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

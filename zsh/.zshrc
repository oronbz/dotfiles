export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$HOME/.config/zsh"
ZSH_CACHE_DIR="$ZSH/cache"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump-$ZSH_VERSION"
ZSH_DISABLE_COMPFIX="true"
ZSH_THEME="robbyrussell"
DISABLE_AUTO_TITLE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
zstyle ':omz:update' mode auto
zstyle ':omz:plugins:eza' icons yes
zstyle ':omz:plugins:eza' git-status yes
zstyle ':omz:plugins:eza' dirs-first yes
plugins=(git macos eza history-substring-search)

fpath=(/opt/homebrew/share/zsh-completions /opt/homebrew/share/zsh/site-functions $fpath)
source "$ZSH/oh-my-zsh.sh"

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
cached_init atuin atuin init zsh --disable-up-arrow

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
[[ -f "$HOME/Desktop/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/Desktop/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/Desktop/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/Desktop/google-cloud-sdk/completion.zsh.inc"

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^ ' autosuggest-accept

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=''
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=''
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

ZDOTCONF="$HOME/.config/zsh"

for f in path secrets aliases git functions; do
  [[ -r "$ZDOTCONF/$f.zsh" ]] && source "$ZDOTCONF/$f.zsh"
done

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history hist_expire_dups_first hist_ignore_dups hist_ignore_space
setopt hist_verify share_history inc_append_history
setopt auto_cd interactive_comments long_list_jobs no_beep

bindkey -e
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

fpath=(/opt/homebrew/share/zsh-completions /opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz compinit
() {
  setopt local_options extended_glob
  if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then compinit; else compinit -C; fi
}
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

source <(fzf --zsh)
eval "$(zoxide init zsh)"

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
[[ -f "$HOME/Desktop/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/Desktop/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/Desktop/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/Desktop/google-cloud-sdk/completion.zsh.inc"

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^ ' autosuggest-accept

eval "$(starship init zsh)"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

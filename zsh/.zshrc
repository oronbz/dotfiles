ZDOTCONF="$HOME/.config/zsh"

for f in path secrets aliases git functions; do
  [[ -r "$ZDOTCONF/$f.zsh" ]] && source "$ZDOTCONF/$f.zsh"
done

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history hist_expire_dups_first hist_ignore_all_dups hist_ignore_space
setopt hist_verify share_history inc_append_history
setopt auto_cd auto_pushd pushd_ignore_dups pushd_silent interactive_comments long_list_jobs no_beep

bindkey -e
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

fpath=("$ZDOTCONF/completions" /opt/homebrew/share/zsh-completions /opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz compinit
() {
  setopt local_options extended_glob
  if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then compinit; else compinit -C; fi
}
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}%B%d%b%f'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

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

cached_init starship starship init zsh --print-full-init

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

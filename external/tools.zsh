[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f "$HOME/.ghcup/env" ]] && . "$HOME/.ghcup/env"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd zsh)"

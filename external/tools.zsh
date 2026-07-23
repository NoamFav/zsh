# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                       SHELL ENHANCEMENT TOOLS                                ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

command -v thefuck >/dev/null 2>&1 && eval "$(thefuck --alias)"
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f "$HOME/.ghcup/env" ]] && . "$HOME/.ghcup/env"
command -v oh-my-posh >/dev/null 2>&1 && eval "$(oh-my-posh init zsh --config $OMP_PATH)"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd zsh)"

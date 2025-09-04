# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                       SHELL ENHANCEMENT TOOLS                                ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# TheFuck - Intelligent command correction
eval "$(thefuck --alias)"

# fzf - Fuzzy finder for commands, files, and history
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# ghcup - Haskell toolchain manager
[[ -f "$HOME/.ghcup/env" ]] && . "$HOME/.ghcup/env"

# Oh My Posh - Beautiful, customizable prompt
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config-theme.toml)"

# Atuin - Enhanced shell history with sync capabilities
eval "$(atuin init zsh)"

# Zoxide - Smart directory jumping (replaces cd with intelligence)
eval "$(zoxide init --cmd cd zsh)"

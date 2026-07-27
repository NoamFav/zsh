# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                           COMPLETION STYLING                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Configure ZSH completion styling
zstyle ':completion:*' menu select                                    # Enable menu selection
zstyle ':completion:*' group-name ''                                  # Group completions
zstyle ':completion:*:descriptions' format '%B%F{#7aa2f7}%d%f%b'      # Tokyo Night blue descriptions
zstyle ':completion:*:messages' format '%B%U%F{#e0af68}%d%f%u%b'      # Tokyo Night yellow messages
zstyle ':completion:*:warnings' format '%B%U%F{#f7768e}No matches found%f%u%b' # Tokyo Night red warnings
zstyle ':completion:*:default' list-colors ''                        # Tokyo Night file colors via $LS_COLORS (see exports/paths.zsh)

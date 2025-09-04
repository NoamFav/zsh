# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                           COMPLETION STYLING                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Configure ZSH completion styling
zstyle ':completion:*' menu select                                    # Enable menu selection
zstyle ':completion:*' group-name ''                                  # Group completions
zstyle ':completion:*:descriptions' format '%B%F{blue}%d%f%b'        # Blue descriptions
zstyle ':completion:*:messages' format '%B%U%F{yellow}%d%f%u%b'      # Yellow messages
zstyle ':completion:*:warnings' format '%B%U%F{red}No matches found%f%u%b' # Red warnings
zstyle ':completion:*:default' list-colors ''                        # Default colors

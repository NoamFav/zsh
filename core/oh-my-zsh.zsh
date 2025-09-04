# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                           OH MY ZSH CONFIGURATION                            ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Essential plugins for enhanced shell experience
plugins=(
    git                      # Git integration and aliases
    zsh-syntax-highlighting  # Syntax highlighting for commands
    zsh-autosuggestions     # Command suggestions based on history
    zsh-completions         # Additional completions
    fzf-tab                 # Replace default completion with fzf
)

# Load forgit plugin if available (enhanced git experience with fzf)
[[ -f $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh ]] && \
    source "$HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh"

# Initialize Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

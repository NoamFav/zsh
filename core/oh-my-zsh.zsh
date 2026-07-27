# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                           OH MY ZSH CONFIGURATION                            ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Oh My Zsh configuration
export ZSH="$HOME/.dev/oh-my-zsh"
export ZSH_CUSTOM="$HOME/.dev/oh-my-zsh/custom"

# Tokyo Night colors for zsh-syntax-highlighting (must be set before the
# plugin loads below, since it only fills in styles that are still unset).
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f7768e,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#bb9af7'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#9ece6a,underline'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#2ac3de'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#9ece6a,underline'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#9ece6a,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#e0af68'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#7aa2f7'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#bb9af7'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#bb9af7'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#bb9af7'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#bb9af7'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#bb9af7'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#9ece6a'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#9ece6a'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#9ece6a'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#2ac3de'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#e0af68'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#2ac3de'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#2ac3de'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#bb9af7'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#e0af68'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#565f89'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#7aa2f7'

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

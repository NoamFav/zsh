# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                            ZSH HOOKS                                         ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

autoload -Uz add-zsh-hook

# Set up directory change hooks for automatic actions
add-zsh-hook chpwd _onefetch_chpwd  # Show repo info when entering git dirs
add-zsh-hook chpwd alias_web         # Update web alias based on current project

# Initialize for current directory
alias_web

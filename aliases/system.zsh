# Enhanced system commands with modern alternatives
alias ls='eza --icons always'           # Beautiful file listing with icons
alias lt='eza --icons --tree'           # Tree view with icons
alias top='btop'                        # Beautiful system monitor
alias c='clear'                         # Quick clear screen
alias e='exit'                          # Quick exit
alias fucking='sudo'

# File management shortcuts
alias cdhist='zoxide query -l -s | bat' # Show directory navigation history

# Editor shortcuts
alias nv='nvim'                         # Quick nvim launch
alias zc="nv ~/.zshrc"                  # Edit ZSH configuration
alias zs="source ~/.zshrc"              # Reload ZSH configuration
alias omzc="nv ~/.oh-my-zsh"            # Edit Oh My Zsh configuration

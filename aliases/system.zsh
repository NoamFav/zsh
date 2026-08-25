# ── System essentials ───────────────────────────────────────────────────────

alias ls='eza --icons always'
alias lt='eza --icons --tree'
alias top='btop'
alias e='exit'
alias f='fuck' # thefuck
alias ff='fastfetch'
alias of='onefetch'
alias fucking='sudo'

alias dh='diskutil eject HDD'
alias cdhist='zoxide query -l -s | bat'

alias nv='nvim'
alias zc="nv ~/.zshrc"
alias zs="source ~/.zshrc"
alias omzc="nv ~/.oh-my-zsh"
alias line="pbpaste | wc -l"
alias switch="sh ~/.config/aerospace/switch.sh"

c()  { printf '\n%.0s' {1..$LINES}; tput cup 0 0 }
C()  { printf '\033[H\033[2J\033[3J' }

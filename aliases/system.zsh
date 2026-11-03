# ── System essentials ───────────────────────────────────────────────────────

# eza/btop aren't on the cluster by default, keep plain ls/top until installed
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons always'
    alias lt='eza --icons --tree'
fi
command -v btop >/dev/null 2>&1 && alias top='btop'

# Debian/Ubuntu ship these under different names
! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1 && alias bat='batcat'
! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1 && alias fd='fdfind'
alias e='exit'
alias f='fuck' # thefuck
alias ff='fastfetch'
alias of='onefetch'
alias fucking='sudo'

alias cdhist='zoxide query -l -s | bat'

alias nv='nvim'
alias zc="nv ~/.zshrc"
alias zs="source ~/.zshrc"
alias omzc="nv ~/.oh-my-zsh"

c()  { printf '\n%.0s' {1..$LINES}; tput cup 0 0 }
C()  { printf '\033[H\033[2J\033[3J' }

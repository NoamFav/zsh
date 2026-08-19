# ── Zsh hooks ────────────────────────────────────────────────────────────────

autoload -Uz add-zsh-hook

add-zsh-hook chpwd _onefetch_chpwd
add-zsh-hook chpwd alias_web

alias_web

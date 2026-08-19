# ── Completion styling ──────────────────────────────────────────────────────

zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%F{#7aa2f7}%d%f%b'
zstyle ':completion:*:messages' format '%B%U%F{#e0af68}%d%f%u%b'
zstyle ':completion:*:warnings' format '%B%U%F{#f7768e}No matches found%f%u%b'
zstyle ':completion:*:default' list-colors '' # reads $LS_COLORS, set in exports/paths.zsh

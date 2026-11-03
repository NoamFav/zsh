# ── Homebrew utilities ──────────────────────────────────────────────────────

hb_installed() {
    echo "🍺 Browsing installed Homebrew packages..."
    brew list | fzf \
        --prompt="🔍 Select package: " \
        --preview 'brew info {}' \
        --preview-window=right:70% \
        --border=rounded \
        --header="Use ↑↓ to navigate, Enter to select, Esc to quit"
}

hb_search() {
    echo "🍺 Searching all available Homebrew packages..."
    brew search | fzf \
        --prompt="🔍 Search packages: " \
        --preview 'brew info {}' \
        --preview-window=right:70% \
        --border=rounded \
        --header="Use ↑↓ to navigate, Enter to select, Esc to quit"
}

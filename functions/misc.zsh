# ── Onefetch integration ────────────────────────────────────────────────────

_onefetch_chpwd() {
    if [[ -d .git ]]; then
        onefetch
        ls
    fi
}

onelist() {
    echo "🎨 Select a language theme for onefetch"
    onefetch -l | fzf \
        --prompt="🌈 Language theme: " \
        --preview 'onefetch -a "$(echo {1} | tr "[:upper:]" "[:lower:]")"' \
        --preview-window=right:70% \
        --border=rounded
}

# ── Dynamic web aliases ──────────────────────────────────────────────────────

typeset -gA web_aliases=(
    "Psycho"     "https://noamfav.github.io/Psycho"
    "Resume"     "https://noamfav.github.io/Resume"
    "bitvoyager" "https://noamfav.github.io/bitvoyager"
    "NF-Software" "https://nf-software.com"
)

# rebinds `web` to whatever this project's page is, per directory (see hooks/directory.zsh)
alias_web() {
    local project_name="${PWD##*/}"
    if [[ -n ${web_aliases[$project_name]} ]]; then
        alias web="echo '🌐 Opening ${project_name}...' && xdg-open ${web_aliases[$project_name]}"
    else
        unalias web 2>/dev/null
    fi
}

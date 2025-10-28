# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                         ONEFETCH INTEGRATION                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Auto-display repository info when entering git directories
_onefetch_chpwd() {
    if [[ -d .git ]]; then
        onefetch
    fi
}

# Interactive language selection for onefetch theming
onelist() {
    echo "🎨 Select a language theme for onefetch"
    onefetch -l | fzf \
        --prompt="🌈 Language theme: " \
        --preview 'onefetch -a "$(echo {1} | tr "[:upper:]" "[:lower:]")"' \
        --preview-window=right:70% \
        --border=rounded
}

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                        DYNAMIC WEB ALIASES                                   │
# └──────────────────────────────────────────────────────────────────────────────┘

# Project-specific web aliases mapping
typeset -gA web_aliases=(
    "Psycho"     "https://noamfav.github.io/Psycho"
    "Resume"     "https://noamfav.github.io/Resume"
    "bitvoyager" "https://noamfav.github.io/bitvoyager"
    "NF-Software" "https://nf-software.com"
)

# Dynamic web alias based on current directory
alias_web() {
    local project_name="${PWD##*/}"
    if [[ -n ${web_aliases[$project_name]} ]]; then
        alias web="echo '🌐 Opening ${project_name}...' && open -a Safari ${web_aliases[$project_name]}"
    else
        unalias web 2>/dev/null
    fi
}

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                        ITERM2 FUNCTION CLOSE                                 │
# └──────────────────────────────────────────────────────────────────────────────┘

closeiterm() {
  osascript -e 'if application id "com.googlecode.iterm2" is running then tell application id "com.googlecode.iterm2" to close (every window)'
}

quititerm() {
  osascript -e 'if application id "com.googlecode.iterm2" is running then tell application id "com.googlecode.iterm2" to quit'
}

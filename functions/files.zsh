# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                          FILE MANAGEMENT                                     ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Yazi file manager with directory change integration
y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" ]] && [[ "$cwd" != "$PWD" ]]; then
        echo "📂 Navigating to: $cwd"
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Text replacement utility with validation and preview
replace_text() {
    if [[ $# -ne 2 ]]; then
        echo "🔄 Usage: replace_text <old_string> <new_string>"
        echo "📝 Example: replace_text 'old_text' 'new_text'"
        return 1
    fi
    
    local old_string="$1"
    local new_string="$2"
    
    echo "🔍 Searching for files containing: '$old_string'"
    local files=($(grep -rl --binary-files=without-match "$old_string" .))
    
    if [[ ${#files[@]} -eq 0 ]]; then
        echo "❌ No files found containing '$old_string'"
        return 1
    fi
    
    echo "🔄 Found ${#files[@]} file(s). Replacing '$old_string' with '$new_string'..."
    printf '%s\n' "${files[@]}" | xargs sed -i '' "s/$old_string/$new_string/g"
    echo "✅ Replacement completed!"
}

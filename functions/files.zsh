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

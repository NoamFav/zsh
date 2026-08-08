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

repo() {
  local base="${HOME}/Neoware"
  local target
  target=$(fd -t d . "$base"/{00-apps,01-games,02-editor-plugins,03-research,04-coursework,05-configs,06-experiments} 2>/dev/null \
    | grep -v "/.git" | fzf --prompt="repo> ") || return
  cd "$target"
}

# project tree quicklook
ptree() { tree -L "${1:-2}" -d -I ".git"; }

batcopy() {
  local -a sel files
  local f

  sel=("${(@f)$(fzf -m --preview '[[ -d {} ]] && tree -L 2 {} || bat --color=always -- {}' )}")
  (( ${#sel} == 0 )) && return

  files=()
  for f in "${sel[@]}"; do
    if [[ -d "$f" ]]; then
      files+=("$f"/*.*(N))
    else
      files+=("$f")
    fi
  done

  (( ${#files} == 0 )) && return
  bat --color=always -- "${files[@]}" 2>/dev/null | pbcopy
}

goup() {
  local bin pkg
  for bin in "$(go env GOPATH)"/bin/*(N.x); do
    pkg=$(go version -m "$bin" 2>/dev/null | awk '$1 == "path" {print $2}')
    [[ -n "$pkg" ]] && go install "$pkg@latest"
  done
}

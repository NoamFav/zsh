typeset -TUx DOWNLOADS downloads
downloads=(
    "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Downloads"
    "$HOME/Downloads"
    )

dl() {ls -ld -s modified ${^downloads}/*(N)}

dlf() {
  local d
  for d in $downloads; do
    [[ -e $d/$1 ]] && { print -r -- "$d/$1"; return 0 }
  done
  print -u2 "dlf: $1: not in downloads"
  return 1
}

_dlf() { _files -W downloads }   # -W accepts an array name, so tab completes across both dirs
compdef _dlf dlf

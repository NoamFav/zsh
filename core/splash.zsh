
if [[ "$TERM_PROGRAM" == "ghostty" && -o interactive && -z "$GHOSTTY_SPLASH_SHOWN" ]]; then
  export GHOSTTY_SPLASH_SHOWN=1

  _gradient_print() {
    local start_hex="$1" end_hex="$2"
    shift 2
    local -a lines=("$@")
    local sr sg sb er eg eb
    sr=$((16#${start_hex[1,2]})); sg=$((16#${start_hex[3,4]})); sb=$((16#${start_hex[5,6]}))
    er=$((16#${end_hex[1,2]}));   eg=$((16#${end_hex[3,4]}));   eb=$((16#${end_hex[5,6]}))
    local n=${#lines[@]}
    local i r g b t line
    for ((i = 1; i <= n; i++)); do
      line="${lines[$i]}"
      if (( n > 1 )); then
        t=$(( (i - 1.0) / (n - 1.0) ))
      else
        t=0
      fi
      r=$(( sr + (er - sr) * t ))
      g=$(( sg + (eg - sg) * t ))
      b=$(( sb + (eb - sb) * t ))
      printf "\033[38;2;%.0f;%.0f;%.0fm%s\033[0m\n" "$r" "$g" "$b" "$line"
    done
  }

  if command -v figlet &>/dev/null; then
    local -a _splash_lines
    # Swap "NF" for whatever initials/word you want as your mark
    _splash_lines=("${(@f)$(figlet -f big "NF")}")
    echo
    _gradient_print "7aa2f7" "bb9af7" "${_splash_lines[@]}"
    printf "\033[38;2;65;72;104m%s\033[0m\n" "────────────────────────────────────"
    echo
  fi

  unfunction _gradient_print
fi


# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                               ARDUINO CONFIG                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Arduino CLI dependency check
if ! command -v arduino-cli >/dev/null || ! command -v fzf >/dev/null || ! command -v jq >/dev/null; then
    echo "⚠️  Arduino functions require: arduino-cli, fzf, jq"
else
    # Arduino environment variables
    export ARD_FQBN=""  # Fully Qualified Board Name
    export ARD_PORT=""  # Serial port

    # Port picker with interactive selection
    _arduino_pick_port() {
        local line port fqbn
        line="$(arduino-cli board list --format json \
            | jq -r '.[] | .port.address as $p
                      | ( .matching_boards[0].name // "Unknown" ) as $n
                      | ( .matching_boards[0].fqbn // "-" )  as $f
                      | "\($p)\t\($n)\t\($f)"' \
            | fzf --prompt='🔌 Port > ' --with-nth=1,2 --delimiter=$'\t' --height=60% --reverse)" || return 1

        port="$(printf '%s' "$line" | awk -F'\t' '{print $1}')"
        fqbn="$(printf '%s' "$line" | awk -F'\t' '{print $3}')"

        export ARD_PORT="$port"
        export ARD_FQBN="$fqbn"
        echo "=> Port:  $ARD_PORT"
        echo "=> Board: $ARD_FQBN"
    }

    # Board picker for manual override
    ard-pick-board() {
        local line fqbn
        line="$(arduino-cli board listall | fzf --prompt='🔧 Board > ' --height=60% --reverse)" || return 1
        fqbn="$(printf '%s' "$line" | awk -F'[()]' '{print $(NF-1)}')"
        [[ -n "$fqbn" ]] || { echo "Could not parse FQBN from: $line"; return 1; }
        export ARD_FQBN="$fqbn"
        echo "=> Board set: $ARD_FQBN"
    }

    # Sketch picker with fd or find fallback
    _arduino_pick_sketch() {
        local sk
        if command -v fd >/dev/null; then
            sk="$(fd -t f -e ino . 2>/dev/null | fzf --prompt='📝 Sketch > ' --height=60% --reverse)" || return 1
        else
            sk="$(find . -type f -name '*.ino' 2>/dev/null | fzf --prompt='📝 Sketch > ' --height=60% --reverse)" || return 1
        fi
        print -r -- "$sk"
    }

    # Compile Arduino sketch
    ard-c() {
        local sketch="${1:-}"
        if [[ -z "$ARD_FQBN" ]]; then _arduino_pick_port || return 1; fi
        if [[ -z "$sketch" ]]; then sketch="$(_arduino_pick_sketch)" || return 1; fi
        echo "🔨 Compiling $sketch for $ARD_FQBN"
        arduino-cli compile --fqbn "$ARD_FQBN" "$sketch"
    }

    # Upload Arduino sketch
    ard-u() {
        local sketch="${1:-}"
        if [[ -z "$ARD_FQBN" ]]; then _arduino_pick_port || return 1; fi
        if [[ -z "$ARD_PORT" ]];  then _arduino_pick_port || return 1; fi
        if [[ -z "$sketch" ]];   then sketch="$(_arduino_pick_sketch)" || return 1; fi
        echo "⬆️  Uploading $sketch to $ARD_PORT as $ARD_FQBN"
        arduino-cli upload -p "$ARD_PORT" --fqbn "$ARD_FQBN" "$sketch"
    }

    # Fast compilation with manual parameters
    ard-cb() { 
        [[ $# -lt 2 ]] && { echo "Usage: ard-cb <fqbn> <sketch.ino>"; return 1; }
        arduino-cli compile --fqbn "$1" "$2"
    }

    # Fast upload with manual parameters
    ard-ub() {
        [[ $# -lt 2 ]] && { echo "Usage: ard-ub <fqbn> <sketch.ino> [port]"; return 1; }
        local port="${3:-$(_arduino_pick_port >/dev/null && print -r -- "$ARD_PORT")}"
        [[ -z "$port" ]] && return 1
        arduino-cli upload -p "$port" --fqbn "$1" "$2"
    }
fi

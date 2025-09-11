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

    # Only offer ports that actually have a matching board (FQBN present)
    _arduino_pick_port() {
      local line
      line="$(
        arduino-cli board list --format json \
        | jq -r '
            .detected_ports[]?
            | select(.matching_boards and (.matching_boards|length>0))
            | .port.address as $p
            | .matching_boards[0].name as $n
            | .matching_boards[0].fqbn as $f
            | "\($p)\t\($n)\t\($f)"
          ' \
        | fzf --prompt='Port > ' --with-nth=1,2 --delimiter=$'\t' --height=60% --reverse
      )" || return 1

      export ARD_PORT="${line%%$'\t'*}"
      export ARD_FQBN="$(printf '%s' "$line" | awk -F'\t' '{print $3}')"
      echo "=> Port:  $ARD_PORT"
      echo "=> Board: $ARD_FQBN"
    }

    # Normalize a user-provided path (file or dir) to a *sketch root directory*
    _arduino_pick_sketch() {
      local list
      if command -v fd >/dev/null; then
        list="$(fd -t f -e ino . \
          | while IFS= read -r f; do
              b="$(basename "${f%.ino}")"
              d="$(basename "$(dirname "$f")")"
              [[ "$b" == "$d" ]] && dirname "$f"
            done | sort -u)"
      else
        list="$(find . -type f -name '*.ino' -print0 \
          | xargs -0 -I{} sh -c '
              f="$1"; b=$(basename "${f%.ino}"); d=$(basename "$(dirname "$f")");
              [ "$b" = "$d" ] && dirname "$f"
            ' _ {} | sort -u)"
      fi
      [[ -n "$list" ]] || { echo "No valid sketches (need <dir>/<dir>.ino)"; return 1; }
      printf '%s\n' "$list" | fzf --prompt='📝 Sketch > ' --height=60% --reverse
    }

    # Compile (accept dir or file; normalize to dir)
    ard-c() {
      local in="${1:-}" sketch
      [[ -n "$ARD_FQBN" ]] || _arduino_pick_port || return 1
      if [[ -z "$in" ]]; then
        sketch="$(_arduino_pick_sketch)" || return 1
      else
        sketch="$(_arduino_normalize_sketch "$in")" || { echo "Not a valid sketch: $in"; return 1; }
      fi
      echo "🔨 Compiling $sketch for $ARD_FQBN"
      arduino-cli compile --fqbn "$ARD_FQBN" "$sketch"
    }

    # Upload (accept dir or file; normalize to dir)
    ard-u() {
      local in="${1:-}" sketch
      [[ -n "$ARD_FQBN" ]] || _arduino_pick_port || return 1
      [[ -n "$ARD_PORT"  ]] || _arduino_pick_port || return 1
      if [[ -z "$in" ]]; then
        sketch="$(_arduino_pick_sketch)" || return 1
      else
        sketch="$(_arduino_normalize_sketch "$in")" || { echo "Not a valid sketch: $in"; return 1; }
      fi
      echo "⬆️  Uploading $sketch to $ARD_PORT as $ARD_FQBN"
      arduino-cli upload -p "$ARD_PORT" --fqbn "$ARD_FQBN" "$sketch"
    }

    # Manual fast paths still work; they can take a sketch *dir*
    ard-cb() { [[ $# -lt 2 ]] && { echo "Usage: ard-cb <fqbn> <sketch_dir|main.ino>"; return 1; }
               local s; s="$(_arduino_normalize_sketch "$2")" || { echo "Not a valid sketch: $2"; return 1; }
               arduino-cli compile --fqbn "$1" "$s"; }

    ard-ub() { [[ $# -lt 2 ]] && { echo "Usage: ard-ub <fqbn> <sketch_dir|main.ino> [port]"; return 1; }
               local s p; s="$(_arduino_normalize_sketch "$2")" || { echo "Not a valid sketch: $2"; return 1; }
               p="${3:-$(_arduino_pick_port >/dev/null && printf '%s' "$ARD_PORT")}"
               [[ -n "$p" ]] || return 1
               arduino-cli upload -p "$p" --fqbn "$1" "$s"; }
fi

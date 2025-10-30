# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                           ZSH CONFIGURATION                                  ║
# ║                        ~ Modular Terminal Setup ~                            ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

export ZSH_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
[[ -d "$ZSH_CONFIG_DIR" ]] || mkdir -p "$ZSH_CONFIG_DIR"

# Local overrides
[[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && source "$ZSH_CONFIG_DIR/local.zsh"
[[ -f "$HOME/.secrets.env" ]] && source "$HOME/.secrets.env"


# Load modules in order of dependency
ZSH_MODULES=(
  "core/environment"
  "core/oh-my-zsh"
  "core/completion"
  "exports/paths"
  "exports/libraries"
  "aliases/system"
  "aliases/development"
  "aliases/git"
  "aliases/multimedia"
  "functions/homebrew"
  "functions/git"
  "functions/arduino"
  "functions/files"
  "functions/misc"
  "hooks/directory"
  "external/conda"
  "external/tools"
  "external/completions"
 # "startup/welcome"
)

for module in "${ZSH_MODULES[@]}"; do
  module_file="$ZSH_CONFIG_DIR/$module.zsh"
  if [[ -f "$module_file" ]]; then
    source "$module_file"
  else
    echo "⚠️  Module not found: $module_file"
  fi
done

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                            CONFIGURATION END                                 ║
# ║    💡 Edit individual modules in ~/.config/zsh/ for specific changes         ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

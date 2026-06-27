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
  "aliases/system"
  "aliases/git"
  "functions/files"
  "external/tools"
)

for module in "${ZSH_MODULES[@]}"; do
  module_file="$ZSH_CONFIG_DIR/$module.zsh"
  if [[ -f "$module_file" ]]; then
    source "$module_file"
  else
    echo "⚠️  Module not found: $module_file"
  fi
done

# ── Zsh configuration ───────────────────────────────────────────────────────

export ZSH_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
[[ -d "$ZSH_CONFIG_DIR" ]] || mkdir -p "$ZSH_CONFIG_DIR"

# local.zsh and .secrets.env are both gitignored, machine-specific
[[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && source "$ZSH_CONFIG_DIR/local.zsh"
[[ -f "$HOME/.secrets.env" ]] && source "$HOME/.secrets.env"


# order matters, later modules assume earlier ones already ran (paths before
# aliases that call those tools, oh-my-zsh before things that hook into it)
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
  "functions/gh"
  "functions/arduino"
  "functions/files"
  "functions/misc"
  "hooks/directory"
  "external/conda"
  "external/tools"
  "external/completions"
)

for module in "${ZSH_MODULES[@]}"; do
  module_file="$ZSH_CONFIG_DIR/$module.zsh"
  if [[ -f "$module_file" ]]; then
    source "$module_file"
  else
    echo "⚠️  Module not found: $module_file"
  fi
done

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
#
colorscript -r

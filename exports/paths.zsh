# ── Path management (42 cluster: Linux, no sudo, ~5GB home) ──────────────

# user-level installs only, nothing system-wide is writable here
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -d "$HOME/go/bin" ]] && export PATH="$HOME/go/bin:$PATH"
export DOCKER_CONFIG="$HOME/.dev/docker"

# home is quota'd but goinfre (machine-local, wiped now and then) isn't —
# fine for caches, which can always be rebuilt
if [[ -d "/goinfre/$USER" ]]; then
    export XDG_CACHE_HOME="/goinfre/$USER/.cache"
    mkdir -p "$XDG_CACHE_HOME"
fi

export MANPATH="$HOME/.local/share/man:$MANPATH"
export OMP_PATH="$HOME/.config/zsh/external/oh-my-posh/default.json"
export EZA_CONFIG_DIR="$HOME/.config/eza"

export EZA_COLORS="di=38;2;122;162;247:ln=38;2;42;195;222:ex=38;2;158;206;106:pi=38;2;65;72;104:so=38;2;65;72;104:bd=38;2;224;175;104:cd=38;2;224;175;104:or=38;2;255;0;124"
export LS_COLORS="di=38;2;122;162;247:ln=38;2;42;195;222:ex=38;2;158;206;106:pi=38;2;65;72;104:so=38;2;65;72;104:bd=38;2;224;175;104:cd=38;2;224;175;104:or=38;2;255;0;124:*.go=38;2;42;195;222:*.rs=38;2;255;158;100:*.c=38;2;61;89;161:*.cpp=38;2;122;162;247:*.sh=38;2;158;206;106:*.bash=38;2;158;206;106:*.zsh=38;2;158;206;106:*.ts=38;2;122;162;247:*.js=38;2;224;175;104:*.java=38;2;247;118;142:*.lua=38;2;187;154;247:*.html=38;2;255;158;100:*.py=38;2;224;175;104:*.swift=38;2;255;158;100:*.ino=38;2;26;188;156:*.md=38;2;115;122;162:*.hs=38;2;157;124;216:*.ml=38;2;255;158;100:*.ex=38;2;187;154;247:*.fnl=38;2;42;195;222:*.rb=38;2;219;75;75:*.php=38;2;157;124;216:*.cs=38;2;157;124;216:*.d=38;2;219;75;75:*.f90=38;2;157;124;216:*.fs=38;2;122;162;247:*.gleam=38;2;247;118;142:*.groovy=38;2;122;162;247:*.hc=38;2;224;175;104:*.kt=38;2;187;154;247:*.nim=38;2;224;175;104:*.pl=38;2;61;89;161:*.r=38;2;122;162;247:*.scm=38;2;219;75;75:*.sass=38;2;187;154;247:*.styl=38;2;187;154;247:*.sv=38;2;158;206;106:*.v=38;2;122;162;247:*.tex=38;2;122;162;247:*.asm=38;2;115;122;162:*.clj=38;2;158;206;106:*.cljs=38;2;158;206;106:*.coffee=38;2;224;175;104:*.dart=38;2;42;195;222:*.elm=38;2;122;162;247:*.erl=38;2;219;75;75:*.jl=38;2;157;124;216:*.nix=38;2;42;195;222:*.zig=38;2;255;158;100:*.vue=38;2;158;206;106:*.svelte=38;2;255;158;100:*.twig=38;2;158;206;106:*.yml=38;2;247;118;142:*.yaml=38;2;247;118;142:*.json=38;2;224;175;104:*.toml=38;2;255;158;100:*.xml=38;2;255;158;100:*.sql=38;2;122;162;247:*.graphql=38;2;187;154;247:*.vim=38;2;158;206;106:*.ps1=38;2;61;89;161:*.tf=38;2;187;154;247"


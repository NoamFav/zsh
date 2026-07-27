# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                              PATH MANAGEMENT                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Development Tools
export PATH="/Applications/MATLAB_R2024b.app/bin:$PATH"              # MATLAB
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"                       # Ruby
export PATH="/opt/homebrew/opt/bison/bin:$PATH"                      # Bison parser generator
export PATH="$HOME/go/bin:$PATH"                                     # Go binaries
export PATH="$HOME/.local/bin:$PATH"                                 # Local user binaries
export PATH="$HOME/Library/Python/3.12/bin:$PATH"
export DOCKER_CONFIG="$HOME/.dev/docker"

# .NET Core Configuration
export DOTNET_ROOT="/usr/local/share/dotnet"
export PATH="$DOTNET_ROOT:$PATH"
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="$PATH:/usr/local/share/dotnet"

# MSBuild Environment (for .NET development)
export MSBuildSDKsPath="$DOTNET_ROOT/sdk/$(dotnet --version)/Sdks"
export DOTNET_MSBUILD_SDK_RESOLVER_CLI_DIR="$DOTNET_ROOT"
export DOTNET_MSBUILD_SDK_RESOLVER_SDKS="/usr/local/share/dotnet/sdk"
export MSBUILD_EXE_PATH="/usr/local/share/dotnet/sdk/9.0.102/MSBuild.dll"
export PATH="$MSBUILD_EXE_PATH:$PATH"

# Unity and OmniSharp
export PATH="$HOME/.local/share/omnisharp:$PATH"
export PATH="/Applications/Unity/Hub/Editor/6000.0.31f1/Unity.app/Contents/MacOS:$PATH"

# Java Development Kit
export JAVA_HOME=$(/usr/libexec/java_home -v 23)
export PATH="/opt/homebrew/Cellar/perl/5.40.2/bin:$PATH"

export MANPATH="$HOME/.local/share/man:$MANPATH"
export DXVK_LOG_LEVEL=none
export WINEDLLOVERRIDES="d3d11,dxgi=n"
export OMP_PATH="$HOME/.config/zsh/external/oh-my-posh/default.json"
export EZA_CONFIG_DIR="$HOME/.config/eza"
# eza (v0.23.5) doesn't apply theme.yml's filekinds colors to icons for
# the generic kind-based categories (confirmed broken for directories;
# file_type-categorized files like Brewfile theme correctly). EZA_COLORS
# is a separate override that does reach the icon — used here to patch
# directory plus the other filekinds in the same "not file_type" boat,
# as a precaution since those weren't individually confirmed broken.
export EZA_COLORS="di=38;2;122;162;247:ln=38;2;42;195;222:ex=38;2;158;206;106:pi=38;2;65;72;104:so=38;2;65;72;104:bd=38;2;224;175;104:cd=38;2;224;175;104:or=38;2;255;0;124"
# Matches EZA_COLORS above so zsh's own tab-completion file listings
# (see core/completion.zsh's list-colors) show the same Tokyo Night palette.
export LS_COLORS="di=38;2;122;162;247:ln=38;2;42;195;222:ex=38;2;158;206;106:pi=38;2;65;72;104:so=38;2;65;72;104:bd=38;2;224;175;104:cd=38;2;224;175;104:or=38;2;255;0;124:*.go=38;2;42;195;222:*.rs=38;2;255;158;100:*.c=38;2;61;89;161:*.cpp=38;2;122;162;247:*.sh=38;2;158;206;106:*.bash=38;2;158;206;106:*.zsh=38;2;158;206;106:*.ts=38;2;122;162;247:*.js=38;2;224;175;104:*.java=38;2;247;118;142:*.lua=38;2;187;154;247:*.html=38;2;255;158;100:*.py=38;2;224;175;104:*.swift=38;2;255;158;100:*.ino=38;2;26;188;156:*.md=38;2;115;122;162:*.hs=38;2;157;124;216:*.ml=38;2;255;158;100:*.ex=38;2;187;154;247:*.fnl=38;2;42;195;222:*.rb=38;2;219;75;75:*.php=38;2;157;124;216:*.cs=38;2;157;124;216:*.d=38;2;219;75;75:*.f90=38;2;157;124;216:*.fs=38;2;122;162;247:*.gleam=38;2;247;118;142:*.groovy=38;2;122;162;247:*.hc=38;2;224;175;104:*.kt=38;2;187;154;247:*.nim=38;2;224;175;104:*.pl=38;2;61;89;161:*.r=38;2;122;162;247:*.scm=38;2;219;75;75:*.sass=38;2;187;154;247:*.styl=38;2;187;154;247:*.sv=38;2;158;206;106:*.v=38;2;122;162;247:*.tex=38;2;122;162;247:*.asm=38;2;115;122;162:*.clj=38;2;158;206;106:*.cljs=38;2;158;206;106:*.coffee=38;2;224;175;104:*.dart=38;2;42;195;222:*.elm=38;2;122;162;247:*.erl=38;2;219;75;75:*.jl=38;2;157;124;216:*.nix=38;2;42;195;222:*.zig=38;2;255;158;100:*.vue=38;2;158;206;106:*.svelte=38;2;255;158;100:*.twig=38;2;158;206;106:*.yml=38;2;247;118;142:*.yaml=38;2;247;118;142:*.json=38;2;224;175;104:*.toml=38;2;255;158;100:*.xml=38;2;255;158;100:*.sql=38;2;122;162;247:*.graphql=38;2;187;154;247:*.vim=38;2;158;206;106:*.ps1=38;2;61;89;161:*.tf=38;2;187;154;247"
# export EZA_COLORS="fi=38;2;192;202;245:di=38;2;122;162;247:ln=38;2;42;195;222:pi=38;2;65;72;104:bd=38;2;224;175;104:cd=38;2;224;175;104:so=38;2;65;72;104:sp=38;2;157;124;216:ex=38;2;158;206;106:mp=38;2;180;249;248:ur=38;2;42;195;222:uw=38;2;187;154;247:ux=38;2;158;206;106:ue=38;2;158;206;106:gr=38;2;42;195;222:gw=38;2;255;158;100:gx=38;2;158;206;106:tr=38;2;42;195;222:tw=38;2;255;0;124:tx=38;2;158;206;106:su=38;2;255;0;124:sf=38;2;219;75;75:xa=38;2;115;122;162:df=38;2;42;195;222:ds=38;2;157;124;216:nb=38;2;169;177;214:nk=38;2;137;221;255:nm=38;2;42;195;222:ng=38;2;255;158;100:nt=38;2;255;0;124:ub=38;2;169;177;214:uk=38;2;137;221;255:um=38;2;42;195;222:ug=38;2;255;158;100:ut=38;2;255;0;124:uu=38;2;61;89;161:uR=38;2;187;154;247:un=38;2;42;195;222:gu=38;2;137;221;255:gR=38;2;187;154;247:gn=38;2;192;202;245:lc=38;2;137;221;255:lm=38;2;42;195;222:ga=38;2;158;206;106:gm=38;2;187;154;247:gd=38;2;219;75;75:gv=38;2;42;195;222:gt=38;2;42;195;222:gi=38;2;84;92;126:gc=38;2;255;158;100:Gm=38;2;115;122;162:Go=38;2;180;249;248:Gc=38;2;41;46;66:Gd=38;2;187;154;247:Su=38;2;115;122;162:Sr=38;2;42;195;222:St=38;2;61;89;161:Sl=38;2;157;124;216:im=38;2;137;221;255:vi=38;2;180;249;248:mu=38;2;115;218;202:lo=38;2;65;166;181:cr=38;2;219;75;75:do=38;2;169;177;214:co=38;2;255;158;100:tm=38;2;115;122;162:cm=38;2;115;122;162:bu=38;2;26;188;156:sc=38;2;187;154;247:xx=38;2;65;72;104:da=38;2;224;175;104:in=38;2;115;122;162:bl=38;2;115;122;162:hd=38;2;169;177;214:oc=38;2;255;158;100:ff=38;2;157;124;216:lp=38;2;137;221;255:cc=38;2;255;158;100:or=38;2;255;0;124:bO=38;2;255;0;124"

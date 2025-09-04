# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                              PATH MANAGEMENT                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Development Tools
export PATH="/Applications/MATLAB_R2024b.app/bin:$PATH"              # MATLAB
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"                       # Ruby
export PATH="/opt/homebrew/opt/bison/bin:$PATH"                      # Bison parser generator
export PATH="$HOME/go/bin:$PATH"                                     # Go binaries
export PATH="$HOME/.local/bin:$PATH"                                 # Local user binaries

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

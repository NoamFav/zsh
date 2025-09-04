# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                          DEVELOPMENT TOOLS                                   ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Modern C++ compilation with latest standards
alias g++='g++ -std=c++23'              # GCC with C++23
alias clang++='clang++ -std=c++23'      # Clang with C++23

# Java development
alias mvnfx='mvn clean javafx:run'      # Maven JavaFX runner

# .NET development utilities
alias dotnet-version="dotnet --version && msbuild --version"
alias msbuild="/usr/local/share/dotnet/dotnet msbuild"

# NPM workflow shortcuts
alias nrd="npm run dev"                 # Development server
alias nrb="npm run build"               # Build project
alias nrs="npm run start"               # Start application
alias nrt="npm run test"                # Run tests
alias nru="npm run update"              # Update dependencies
alias nrdp="npm run deploy"             # Deploy project

# Custom project scripts
alias cmr='./run.sh'                    # Common run script

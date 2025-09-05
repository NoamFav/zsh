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


alias ard-run='arduino-cli compile --fqbn adafruit:samd:adafruit_feather_m0 . \
  && arduino-cli upload --fqbn adafruit:samd:adafruit_feather_m0 -p /dev/cu.usbmodem123201 . \
  && arduino-cli board attach -p /dev/cu.usbmodem123201 --fqbn adafruit:samd:adafruit_feather_m0 . \
  && arduino-cli monitor -p /dev/cu.usbmodem123201 -c baudrate=115200'

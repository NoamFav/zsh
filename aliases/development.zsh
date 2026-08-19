# ── Development tools ───────────────────────────────────────────────────────

# always want the newer standard, not whatever the compiler defaults to
alias g++='g++ -std=c++23'
alias clang++='clang++ -std=c++23'

alias mvnfx='mvn clean javafx:run'

alias dotnet-version="dotnet --version && msbuild --version"
alias msbuild="/usr/local/share/dotnet/dotnet msbuild"

# npm shortcuts
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrs="npm run start"
alias nrt="npm run test"
alias nru="npm run update"
alias nrdp="npm run deploy"

alias cmr='./run.sh'

alias ws='whisper-stream -m ~/.models/whisper/ggml-large-v3-turbo.bin --step 1000 --length 5000 -vth 0.7 -t 8'

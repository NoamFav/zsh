# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                            LIBRARY PATHS                                     ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Dynamic Library Paths for macOS
export DYLD_LIBRARY_PATH="/opt/homebrew/opt/openal-soft/lib:$DYLD_LIBRARY_PATH"
export DYLD_LIBRARY_PATH="$HOME/Neoware/iris_initiative/third_party/porcupine/lib/libpv_porcupine.dylib:$DYLD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$HOME/iris.ai/libphonemizer_phonemize-arm64/lib:${LD_LIBRARY_PATH:-}"
# C++ Development Headers
export CPLUS_INCLUDE_PATH="/opt/homebrew/include:$CPLUS_INCLUDE_PATH"
export CPLUS_INCLUDE_PATH="/opt/homebrew/include/onnxruntime:$CPLUS_INCLUDE_PATH"

# Gurobi Optimization Suite
export GUROBI_HOME="/Library/gurobi<version>"
export PATH="${GUROBI_HOME}/bin:${PATH}"
export LD_LIBRARY_PATH="${GUROBI_HOME}/lib:${LD_LIBRARY_PATH}"

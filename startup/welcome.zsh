# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                          WELCOME MESSAGE                                     ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Pretty header with date/time
echo
echo "┌───────────────────────────────────────────────┐"
echo "│   Welcome back, $USER!                       │"
echo "│   $(date '+%A, %B %d %Y - %H:%M:%S')         │"
echo "└───────────────────────────────────────────────┘"
echo

# System summary (fastfetch handles most eye candy)
fastfetch

# Git overview: show uncommitted repos at a glance
if command -v gitcheck >/dev/null 2>&1; then
  echo
  echo "📂 Repositories overview:"
  gitcheck ~/Neoware/*/ ~/.config/*/ | grep -v "📁 not a git repo"
fi

# Pending Homebrew upgrades
if command -v brew >/dev/null 2>&1; then
  updates=$(brew outdated --quiet | wc -l | tr -d ' ')
  if [ "$updates" -gt 0 ]; then
    echo
    echo "🍺 Homebrew: $updates packages can be upgraded (run 'brew upgrade')"
  fi
fi

# Conda environments (if installed)
if command -v conda >/dev/null 2>&1; then
  echo
  echo "🐍 Conda environments:"
  conda env list | grep -v "^#"
fi

# Helpful footer
echo
echo "💡 Pro Tips:"
echo "   zc   → edit config"
echo "   zs   → reload config"
echo "   hb_search / hb_installed → brew helper"
echo "   gitcheck   → repo status overview"
echo "   lg         → LazyGit TUI"
echo "   y          → Yazi file manager"
echo "   sb [cmd]   → SketchyBar control"
echo

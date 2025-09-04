# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                        GIT & PROJECT MANAGEMENT                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Git workflow shortcuts
alias q='auto_commit --only "${PWD##*/}"'                    # Quick commit current project
alias qc='auto_commit --only "${PWD##*/}" --dir ~/.config'   # Quick commit config changes
alias auto='auto_commit'                                     # Auto commit all projects
alias lg='lazygit'                                           # Beautiful git TUI

# Project navigation
alias rp='cd ~/Neoware'                 # Jump to main repository hub
alias nlp='cd ~/Neoware/NLP_project'    # Jump to NLP project

# External services
alias github='open -a Safari "https://github.com/NoamFav"'  # Open GitHub profile

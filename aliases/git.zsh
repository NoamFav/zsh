# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                        GIT & PROJECT MANAGEMENT                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Git workflow shortcuts
alias q='autocommit --only "${PWD##*/}"'                    # Quick commit current project
alias qc='autocommit --only "${PWD##*/}" --dir ~/.config'   # Quick commit config changes
alias auto='autocommit'                                     # Auto commit all projects
alias lg='lazygit'                                           # Beautiful git TUI

# Project navigation
alias rp='cd ~/Neoware'                 # Jump to main repository hub
alias nlp='cd ~/Neoware/NLP_project'    # Jump to NLP project

# External services
alias github='open -a Safari "https://github.com/NoamFav"'  # Open GitHub profile

alias apps='cd ~/Neoware/00-apps'
alias web='cd ~/Neoware/01-websites'
alias games='cd ~/Neoware/02-games'
alias plugs='cd ~/Neoware/03-editor-plugins'
alias study='cd ~/Neoware/04-coursework'
alias research='cd ~/Neoware/05-research'
alias cfg='cd ~/Neoware/06-configs'
alias exp='cd ~/Neoware/07-experiments'


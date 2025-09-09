#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                       SYSTEM INITIALIZATION SEQUENCE                        ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Colors and styling
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Animation delay
DELAY=0.02

# Typing animation function
type_text() {
    local text="$1"
    local color="${2:-$WHITE}"
    for ((i=0; i<${#text}; i++)); do
        printf "${color}%c${RESET}" "${text:$i:1}"
        sleep $DELAY
    done
    echo
}

# Progress bar animation
progress_bar() {
    local duration=$1
    local label="$2"
    local width=40
    
    echo -n "${CYAN}${label}${RESET} ["
    for ((i=0; i<=width; i++)); do
        printf "${GREEN}█${RESET}"
        printf "%*s" $((width-i)) "" | tr ' ' '░'
        printf "${RESET}] %3d%%" $((i*100/width))
        sleep $(echo "scale=3; $duration/$width" | bc -l 2>/dev/null || echo "0.05")
        printf "\r${CYAN}${label}${RESET} ["
    done
    printf "${GREEN}%*s${RESET}] ${GREEN}100%%${RESET}\n" $width | tr ' ' '█'
}

clear

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                            BOOT SEQUENCE                                    ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

echo -e "${CYAN}┌─────────────────────────────────────────────────────────────────────────────┐${RESET}"
echo -e "${CYAN}│${RESET} ${BOLD}SYSTEM INITIALIZATION${RESET}                                                    ${CYAN}│${RESET}"
echo -e "${CYAN}└─────────────────────────────────────────────────────────────────────────────┘${RESET}"
echo

# System checks with progress bars
progress_bar 0.8 "Loading kernel modules    "
progress_bar 0.6 "Mounting filesystems      "
progress_bar 0.4 "Starting network services "
progress_bar 0.5 "Initializing user session "

echo
type_text "✓ System ready. Welcome back, $USER." "$GREEN"
sleep 0.5

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                          SYSTEM STATUS DISPLAY                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

clear
echo -e "${MAGENTA}"
cat << 'EOF'
    ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗     
    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║     
       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║     
       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║     
       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗
       ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝
EOF
echo -e "${RESET}"

# Header with enhanced styling
echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║${RESET}                           ${BOLD}SYSTEM STATUS OVERVIEW${RESET}                           ${CYAN}║${RESET}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════════════════════════════╣${RESET}"
echo -e "${CYAN}║${RESET} User: ${GREEN}$USER${RESET}                      Time: ${YELLOW}$(date '+%A, %B %d %Y - %H:%M:%S')${RESET} ${CYAN}║${RESET}"
echo -e "${CYAN}║${RESET} Host: ${GREEN}$(hostname)${RESET}                 Uptime: ${YELLOW}$(uptime | awk '{print $3,$4}' | sed 's/,//')${RESET}     ${CYAN}║${RESET}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo

# System information in a grid layout
echo -e "${BLUE}┌─────────────────────────┬─────────────────────────┬─────────────────────────┐${RESET}"
echo -e "${BLUE}│${RESET}       ${BOLD}HARDWARE${RESET}         ${BLUE}│${RESET}       ${BOLD}STORAGE${RESET}          ${BLUE}│${RESET}       ${BOLD}NETWORK${RESET}          ${BLUE}│${RESET}"
echo -e "${BLUE}├─────────────────────────┼─────────────────────────┼─────────────────────────┤${RESET}"

# CPU info
cpu_info=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || grep "model name" /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | sed 's/^ *//' || echo "Unknown CPU")
cpu_short=$(echo "$cpu_info" | awk '{print $1,$2,$3}')

# Memory info
if command -v vm_stat >/dev/null 2>&1; then
    # macOS
    mem_total=$(echo "$(sysctl -n hw.memsize) / 1024 / 1024 / 1024" | bc)
    mem_used=$(vm_stat | awk '/Pages active:/{active=$3} /Pages wired down:/{wired=$4} END{printf "%.0f", (active+wired)*4/1024}')
elif [ -f /proc/meminfo ]; then
    # Linux
    mem_total=$(awk '/MemTotal:/{printf "%.0f", $2/1024/1024}' /proc/meminfo)
    mem_used=$(awk '/MemTotal:/{total=$2} /MemFree:/{free=$2} /Buffers:/{buffers=$2} /Cached:/{cached=$2} END{printf "%.0f", (total-free-buffers-cached)/1024/1024}' /proc/meminfo)
else
    mem_total="N/A"
    mem_used="N/A"
fi

# Disk info
disk_usage=$(df -h / 2>/dev/null | awk 'NR==2{print $3"/"$2" ("$5")"}' || echo "N/A")

# Network info
if command -v ifconfig >/dev/null 2>&1; then
    ip_addr=$(ifconfig | grep "inet " | grep -v "127.0.0.1" | head -1 | awk '{print $2}')
elif command -v ip >/dev/null 2>&1; then
    ip_addr=$(ip route get 8.8.8.8 2>/dev/null | grep src | awk '{print $7}' | head -1)
else
    ip_addr="N/A"
fi

echo -e "${BLUE}│${RESET} CPU: ${cpu_short:0:20}... ${BLUE}│${RESET} Root: ${disk_usage:0:18}... ${BLUE}│${RESET} IP: ${ip_addr:-N/A}             ${BLUE}│${RESET}"
echo -e "${BLUE}│${RESET} RAM: ${mem_used:-N/A}/${mem_total:-N/A} GB           ${BLUE}│${RESET} $(df -h /tmp 2>/dev/null | awk 'NR==2{print "Tmp: "$3"/"$2" ("$5")"}' | head -c 23 || echo "Tmp: N/A              ") ${BLUE}│${RESET} $(ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "Status: ${GREEN}Online${RESET}" || echo "Status: ${RED}Offline${RESET}")      ${BLUE}│${RESET}"
echo -e "${BLUE}│${RESET} $(sysctl -n hw.ncpu 2>/dev/null || nproc 2>/dev/null || echo "N/A") CPU Cores             ${BLUE}│${RESET}                         ${BLUE}│${RESET}                         ${BLUE}│${RESET}"
echo -e "${BLUE}└─────────────────────────┴─────────────────────────┴─────────────────────────┘${RESET}"
echo

# System monitoring with visual indicators
echo -e "${YELLOW}┌─────────────────────────────────────────────────────────────────────────────┐${RESET}"
echo -e "${YELLOW}│${RESET}                              ${BOLD}LIVE METRICS${RESET}                               ${YELLOW}│${RESET}"
echo -e "${YELLOW}└─────────────────────────────────────────────────────────────────────────────┘${RESET}"

# CPU usage bar
if command -v top >/dev/null 2>&1; then
    cpu_usage=$(top -l 1 -s 0 2>/dev/null | grep "CPU usage" | awk '{print $3}' | sed 's/%//' || echo "0")
elif command -v htop >/dev/null 2>&1; then
    cpu_usage=$(htop -d 0.1 -n 1 2>/dev/null | grep "%" | head -1 | awk '{print $1}' | sed 's/%//' || echo "0")
else
    cpu_usage=0
fi

# Memory usage bar
if [ "$mem_total" != "N/A" ] && [ "$mem_used" != "N/A" ]; then
    mem_percent=$(echo "scale=0; $mem_used * 100 / $mem_total" | bc 2>/dev/null || echo "0")
else
    mem_percent=0
fi

# Function to create usage bars
create_bar() {
    local usage=$1
    local label="$2"
    local width=20
    local filled=$(echo "scale=0; $usage * $width / 100" | bc 2>/dev/null || echo "0")
    
    printf "%-10s [" "$label"
    for ((i=1; i<=width; i++)); do
        if [ $i -le $filled ]; then
            if [ $usage -lt 50 ]; then
                printf "${GREEN}█${RESET}"
            elif [ $usage -lt 80 ]; then
                printf "${YELLOW}█${RESET}"
            else
                printf "${RED}█${RESET}"
            fi
        else
            printf "${DIM}░${RESET}"
        fi
    done
    printf "] %3d%%\n" "$usage"
}

create_bar "$cpu_usage" "CPU"
create_bar "$mem_percent" "Memory"

# Load average
if [ -f /proc/loadavg ]; then
    load_avg=$(cat /proc/loadavg | awk '{print $1}')
elif command -v uptime >/dev/null 2>&1; then
    load_avg=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | sed 's/^ *//')
else
    load_avg="N/A"
fi

echo "Load Avg   [$load_avg]"
echo

# Enhanced system information using fastfetch if available
if command -v fastfetch >/dev/null 2>&1; then
    echo -e "${MAGENTA}┌─────────────────────────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${MAGENTA}│${RESET}                            ${BOLD}DETAILED SYSTEM INFO${RESET}                           ${MAGENTA}│${RESET}"
    echo -e "${MAGENTA}└─────────────────────────────────────────────────────────────────────────────┘${RESET}"
    fastfetch --pipe false
    echo
fi

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                          DEVELOPMENT ENVIRONMENT                            ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

echo -e "${CYAN}┌─────────────────────────────────────────────────────────────────────────────┐${RESET}"
echo -e "${CYAN}│${RESET}                          ${BOLD}DEVELOPMENT STATUS${RESET}                             ${CYAN}│${RESET}"
echo -e "${CYAN}└─────────────────────────────────────────────────────────────────────────────┘${RESET}"

# Git repositories overview with enhanced display
if command -v gitcheck >/dev/null 2>&1; then
    echo -e "${GREEN}📂 Active Repositories:${RESET}"
    echo -e "${DIM}─────────────────────${RESET}"
    gitcheck ~/Neoware/*/ ~/.config/*/ 2>/dev/null | grep -v "📁 not a git repo" | head -40
    echo
fi

# Package managers status
echo -e "${BLUE}📦 Package Managers:${RESET}"
echo -e "${DIM}────────────────────${RESET}"

# Homebrew status
if command -v brew >/dev/null 2>&1; then
    updates=$(brew outdated --quiet 2>/dev/null | wc -l | tr -d ' ')
    if [ "$updates" -gt 0 ]; then
        echo -e "   🍺 Homebrew: ${YELLOW}$updates packages${RESET} can be upgraded"
    else
        echo -e "   🍺 Homebrew: ${GREEN}All packages up to date${RESET}"
    fi
fi

# Node.js/npm status
if command -v npm >/dev/null 2>&1; then
    npm_outdated=$(npm outdated -g --depth=0 2>/dev/null | wc -l | tr -d ' ')
    if [ "$npm_outdated" -gt 1 ]; then
        echo -e "   📦 NPM Global: ${YELLOW}$((npm_outdated-1)) packages${RESET} can be updated"
    else
        echo -e "   📦 NPM Global: ${GREEN}Up to date${RESET}"
    fi
fi

# Python/pip status
if command -v pip >/dev/null 2>&1; then
    pip_version=$(pip --version 2>/dev/null | awk '{print $2}')
    echo -e "   🐍 Pip: ${GREEN}v$pip_version${RESET}"
fi

# Conda environments
if command -v conda >/dev/null 2>&1; then
    echo -e "\n${YELLOW}🐍 Conda Environments:${RESET}"
    echo -e "${DIM}──────────────────────${RESET}"
    conda env list | grep -v "^#" | while read env; do
        echo -e "   $env"
    done
fi

echo

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                            QUICK COMMANDS                                   ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

echo -e "${GREEN}┌─────────────────────────────────────────────────────────────────────────────┐${RESET}"
echo -e "${GREEN}│${RESET}                             ${BOLD}QUICK COMMANDS${RESET}                                ${GREEN}│${RESET}"
echo -e "${GREEN}└─────────────────────────────────────────────────────────────────────────────┘${RESET}"

echo -e "${BOLD}⚡ System Control:${RESET}"
echo -e "   ${CYAN}zc${RESET}           → Edit configuration"
echo -e "   ${CYAN}zs${RESET}           → Reload shell configuration"
echo -e "   ${CYAN}htop${RESET}         → System process monitor"
echo -e "   ${CYAN}df -h${RESET}        → Disk usage overview"
echo ""
echo -e "${BOLD}📊 Development Tools:${RESET}"
echo -e "   ${CYAN}lg${RESET}           → LazyGit TUI"
echo -e "   ${CYAN}gitcheck${RESET}     → Repository status overview"
echo -e "   ${CYAN}y${RESET}            → Yazi file manager"
echo -e "   ${CYAN}code .${RESET}       → Open current directory in VS Code"
echo ""
echo -e "${BOLD}🍺 Package Management:${RESET}"
echo -e "   ${CYAN}hb_search${RESET}    → Search Homebrew packages"
echo -e "   ${CYAN}hb_installed${RESET} → List installed packages"
echo -e "   ${CYAN}brew upgrade${RESET} → Update all packages"
echo ""
echo -e "${BOLD}🎨 Interface Control:${RESET}"
echo -e "   ${CYAN}sb [cmd]${RESET}     → SketchyBar control"
echo -e "   ${CYAN}clear${RESET}        → Clear terminal"

echo
echo -e "${BOLD}${GREEN}▶ System initialization complete. Ready for operations.${RESET}"
echo -e "${DIM}$(date '+%H:%M:%S') - Session active for user: $USER${RESET}"
echo

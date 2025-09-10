# Clear screen and set up colors
clear
autoload -U colors && colors

# Check if we're on Linux or macOS for proper commands
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    LINUX=true
elif [[ "$OSTYPE" == "darwin"* ]]; then
    LINUX=false
else
    LINUX=true  # Default to Linux-style
fi

# Boot delay function with more realistic timing
boot_delay() {
    sleep $(awk "BEGIN {print rand() * 0.5 + 0.1}")
}

# Quick delay for rapid boot messages
quick_delay() {
    sleep $(awk "BEGIN {print rand() * 0.1 + 0.02}")
}

# Get real system information
if $LINUX; then
    HOSTNAME=$(hostname)
    USERNAME=$(whoami)
    KERNEL_VERSION=$(uname -r)
    CPU_MODEL=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^ *//' 2>/dev/null || uname -m)
    MEMORY_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print int($2/1024/1024) "GB"}' 2>/dev/null || echo "8GB")
    UPTIME_SEC=$(cut -d. -f1 /proc/uptime 2>/dev/null || echo "0")
    ROOT_DEVICE=$(df / | tail -1 | awk '{print $1}' | sed 's/[0-9]*$//')
else
    # macOS fallbacks
    HOSTNAME=$(hostname)
    USERNAME=$(whoami)
    KERNEL_VERSION=$(uname -r)
    CPU_MODEL=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || uname -m)
    MEMORY_TOTAL=$(sysctl -n hw.memsize 2>/dev/null | awk '{print int($1/1024/1024/1024) "GB"}' || echo "8GB")
    UPTIME_SEC="0"
    ROOT_DEVICE="/dev/disk1s1"
fi

ARCH=$(uname -m)
CURRENT_DATE=$(date "+%Y-%m-%d %H:%M:%S")

# Generate realistic hardware values
TOTAL_RAM_MB=$(echo $MEMORY_TOTAL | sed 's/GB//' | awk '{print $1 * 1024}')
AVAILABLE_RAM_MB=$((TOTAL_RAM_MB - $(shuf -i 200-800 -n 1)))

# Start realistic Linux boot sequence
echo "[    0.000000] Linux version $(uname -r) (gcc version 11.2.0) #1 SMP PREEMPT $(date '+%a %b %d %H:%M:%S UTC %Y')"
quick_delay

echo "[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz root=UUID=$(uuidgen | tr '[:upper:]' '[:lower:]') ro quiet splash"
echo "[    0.000000] KERNEL supported cpus:"
echo "[    0.000000]   Intel GenuineIntel"
echo "[    0.000000]   AMD AuthenticAMD"
quick_delay

echo "[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'"
echo "[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'"
echo "[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'"
echo "[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256"
quick_delay

echo "[    0.000000] BIOS-provided physical RAM map:"
echo "[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable"
echo "[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved"
echo "[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved"
quick_delay

printf "[    0.000000] NX (Execute Disable) protection: active\n"
printf "[    0.000000] SMBIOS 3.0 present.\n"
printf "[    0.000000] DMI: System manufacturer System Product Name/PRIME B450M-A, BIOS $(shuf -i 1000-9999 -n 1) $(date '+%m/%d/%Y')\n"
quick_delay

echo "[    0.000000] tsc: Fast TSC calibration using PIT"
echo "[    0.000000] tsc: Detected $(shuf -i 2800-4200 -n 1).$(shuf -i 100-999 -n 1) MHz processor"
echo "[    0.004000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved"
echo "[    0.004000] e820: remove [mem 0x000a0000-0x000fffff] usable"
quick_delay

echo "[    0.004000] last_pfn = 0x$(printf '%x' $((TOTAL_RAM_MB * 1024 / 4))) max_arch_pfn = 0x400000000"
echo "[    0.004000] MTRR default type: write-back"
echo "[    0.004000] MTRR fixed ranges enabled:"
quick_delay

echo "[    0.008000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT"
echo "[    0.008000] found SMP MP-table at [mem 0x000f5680-0x000f568f]"
boot_delay

echo "[    0.012000] Using GB pages for direct mapping"
echo "[    0.012000] RAMDISK: [mem 0x7e000000-0x7fffffff]"
echo "[    0.012000] ACPI: Early table checksum verification disabled"
echo "[    0.016000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)"
boot_delay

echo "[    0.020000] Zone ranges:"
echo "[    0.020000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]"
echo "[    0.020000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]"
echo "[    0.020000]   Normal   [mem 0x0000000100000000-0x000000$(printf '%x' $((TOTAL_RAM_MB * 1024)))fff]"
boot_delay

echo "[    0.028000] ACPI: PM-Timer IO Port: 0x408"
echo "[    0.028000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])"
echo "[    0.028000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23"
quick_delay

CPU_CORES=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo "4")
echo "[    0.032000] smpboot: Allowing $CPU_CORES CPUs, 0 hotplug CPUs"
for ((i=0; i<CPU_CORES; i++)); do
    echo "[    0.036000] setup_percpu: NR_CPUS:$(shuf -i 8-32 -n 1) nr_cpumask_bits:$CPU_CORES nr_cpu_ids:$CPU_CORES nr_node_ids:1"
done
boot_delay

echo "[    0.040000] percpu: Embedded $(shuf -i 32-64 -n 1) pages/cpu s$(shuf -i 90-120 -n 1)112 r8192 d$(shuf -i 28000-32000 -n 1) u$(shuf -i 200000-300000 -n 1)"
echo "[    0.044000] pcpu-alloc: s$(shuf -i 90-120 -n 1)112 r8192 d$(shuf -i 28000-32000 -n 1) u$(shuf -i 200000-300000 -n 1) alloc=1*2097152"
echo "[    0.044000] pcpu-alloc: [0] 0 1 2 3"
boot_delay

echo "[    0.048000] Built 1 zonelists, mobility grouping on.  Total pages: $(shuf -i 1900000-2100000 -n 1)"
echo "[    0.048000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz root=UUID=$(uuidgen | tr '[:upper:]' '[:lower:]') ro quiet splash"
echo "[    0.052000] Dentry cache hash table entries: $(shuf -i 1000000-2000000 -n 1) (order: $(shuf -i 11-13 -n 1), $(shuf -i 8000-16000 -n 1) bytes)"
quick_delay

echo "[    0.056000] Inode-cache hash table entries: $(shuf -i 500000-1000000 -n 1) (order: $(shuf -i 10-12 -n 1), $(shuf -i 4000-8000 -n 1) bytes)"
echo "[    0.060000] mem auto-init: stack:byref_all(zero), heap alloc:on, heap free:off"
echo "[    0.064000] Memory: ${AVAILABLE_RAM_MB}MB/${TOTAL_RAM_MB}MB available ($(shuf -i 12000-16000 -n 1)K kernel code, $(shuf -i 2500-3500 -n 1)K rwdata, $(shuf -i 4000-6000 -n 1)K rodata, $(shuf -i 2500-3500 -n 1)K init, $(shuf -i 2000-3000 -n 1)K bss, $(shuf -i 400-800 -n 1)MB reserved, 0K cma-reserved)"
boot_delay

echo "[    0.068000] SLUB: HWalign=$(shuf -i 32-64 -n 1), Order=0-3, MinObjects=0, CPUs=$CPU_CORES, Nodes=1"
echo "[    0.072000] ftrace: allocating $(shuf -i 35000-45000 -n 1) entries in $(shuf -i 140-180 -n 1) pages"
echo "[    0.076000] ftrace: allocated $(shuf -i 140-180 -n 1) pages with 4 groups"
boot_delay

echo "[    0.080000] rcu: Preemptible hierarchical RCU implementation."
echo "[    0.080000] rcu:     RCU restricting CPUs from NR_CPUS=$(shuf -i 16-32 -n 1) to nr_cpu_ids=$CPU_CORES."
echo "[    0.084000] rcu: RCU calculated value of scheduler-enlistment delay is 30 jiffies."
echo "[    0.084000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=$CPU_CORES"
quick_delay

echo "[    0.088000] NR_IRQS: $(shuf -i 4352-8192 -n 1), nr_irqs: 488, preallocated irqs: 16"
echo "[    0.092000] Console: colour dummy device 80x25"
echo "[    0.092000] printk: console [tty0] enabled"
echo "[    0.096000] ACPI: Core revision $(shuf -i 20190215-20220331 -n 1)"
boot_delay

echo "[    0.100000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 79635855245 ns"
echo "[    0.100000] APIC: Switch to symmetric I/O mode setup"
echo "[    0.104000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1"
echo "[    0.148000] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x$(printf '%x' $(($(shuf -i 2800-4200 -n 1) * 1000000))), max_idle_ns: 440795203504 ns"
boot_delay

echo "[    0.152000] Calibrating delay loop (skipped), value calculated using timer frequency.. $(shuf -i 5600-8400 -n 1).$(shuf -i 10-99 -n 1) BogoMIPS (lpj=$(shuf -i 2800000-4200000 -n 1))"
echo "[    0.152000] pid_max: default: $(shuf -i 32768-65536 -n 1) minimum: 301"
echo "[    0.156000] LSM: Security Framework initializing"
echo "[    0.156000] Yama: becoming mindful."
quick_delay

echo "[    0.160000] AppArmor: AppArmor initialized"
echo "[    0.160000] Mount-cache hash table entries: $(shuf -i 32768-65536 -n 1) (order: $(shuf -i 6-8 -n 1), $(shuf -i 256-512 -n 1) bytes)"
echo "[    0.164000] Mountpoint-cache hash table entries: $(shuf -i 32768-65536 -n 1) (order: $(shuf -i 6-8 -n 1), $(shuf -i 256-512 -n 1) bytes)"
boot_delay

# CPU initialization
for ((i=0; i<CPU_CORES; i++)); do
    if [ $i -eq 0 ]; then
        echo "[    0.$(printf '%03d' $((168 + i*4)))000] smpboot: CPU0: $CPU_MODEL (family: 0x$(printf '%x' $(shuf -i 15-25 -n 1)), model: 0x$(printf '%x' $(shuf -i 60-120 -n 1)), stepping: 0x$(printf '%x' $(shuf -i 0-15 -n 1)))"
    else
        echo "[    0.$(printf '%03d' $((168 + i*4)))000] smp: Bringing up secondary CPUs ..."
        echo "[    0.$(printf '%03d' $((170 + i*4)))000] x86: Booting SMP configuration:"
        echo "[    0.$(printf '%03d' $((172 + i*4)))000] .... node  #0, CPUs:      #$i"
    fi
    quick_delay
done

boot_delay

echo "[    0.$(printf '%03d' $((200 + CPU_CORES*4)))000] smp: Brought up 1 node, $CPU_CORES CPUs"
echo "[    0.$(printf '%03d' $((204 + CPU_CORES*4)))000] smpboot: Max logical packages: 1"
echo "[    0.$(printf '%03d' $((208 + CPU_CORES*4)))000] smpboot: Total of $CPU_CORES processors activated ($(echo "$CPU_CORES * $(shuf -i 5600-8400 -n 1)" | bc).$(shuf -i 10-99 -n 1) BogoMIPS)"
boot_delay

# Device initialization
echo "[    0.$(printf '%03d' $((220 + CPU_CORES*4)))000] devtmpfs: initialized"
echo "[    0.$(printf '%03d' $((224 + CPU_CORES*4)))000] x86/mm: Memory block size: 128MB"
echo "[    0.$(printf '%03d' $((228 + CPU_CORES*4)))000] PM: Registering ACPI NVS region [mem 0x$(printf '%08x' $(shuf -i 268435456-536870912 -n 1))-0x$(printf '%08x' $(shuf -i 536870912-1073741824 -n 1))] ($(shuf -i 65536-131072 -n 1) bytes)"
boot_delay

echo "[    0.$(printf '%03d' $((240 + CPU_CORES*4)))000] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370867519511994 ns"
echo "[    0.$(printf '%03d' $((244 + CPU_CORES*4)))000] futex hash table entries: $(shuf -i 1024-4096 -n 1) (order: $(shuf -i 4-6 -n 1), $(shuf -i 65536-262144 -n 1) bytes)"
echo "[    0.$(printf '%03d' $((248 + CPU_CORES*4)))000] pinctrl core: initialized pinctrl subsystem"
quick_delay

echo "[    0.$(printf '%03d' $((260 + CPU_CORES*4)))000] RTC time: $(date '+%H:%M:%S'), date: $(date '+%m/%d/%y')"
echo "[    0.$(printf '%03d' $((264 + CPU_CORES*4)))000] NET: Registered protocol family 16"
echo "[    0.$(printf '%03d' $((268 + CPU_CORES*4)))000] DMA: preallocated $(shuf -i 256-512 -n 1) KiB pool for atomic allocations"
boot_delay

# PCI subsystem
echo "[    0.$(printf '%03d' $((280 + CPU_CORES*4)))000] PCI: MMCONFIG for domain 0000 [bus 00-$(printf '%02x' $(shuf -i 64-255 -n 1))] at [mem 0x$(printf '%08x' $(shuf -i 3758096384-4026531840 -n 1))-0x$(printf '%08x' $(shuf -i 4026531841-4294967295 -n 1))] (base 0x$(printf '%08x' $(shuf -i 3758096384-4026531840 -n 1))"
echo "[    0.$(printf '%03d' $((284 + CPU_CORES*4)))000] PCI: MMCONFIG at [mem 0x$(printf '%08x' $(shuf -i 3758096384-4026531840 -n 1))-0x$(printf '%08x' $(shuf -i 4026531841-4294967295 -n 1))] reserved in E820"
echo "[    0.$(printf '%03d' $((288 + CPU_CORES*4)))000] PCI: Using configuration type 1 for base access"
boot_delay

# Final boot messages
FINAL_TIME=$(printf '%.3f' $(echo "scale=3; (300 + $CPU_CORES*4)/1000" | bc))
echo "[    $FINAL_TIME] Freeing SMP alternatives memory: $(shuf -i 20-40 -n 1)K"
echo "[    $(echo "$FINAL_TIME + 0.004" | bc)] smpboot: weird, boot CPU (#0) not listed by the BIOS"
echo "[    $(echo "$FINAL_TIME + 0.008" | bc)] smpboot: SMP motherboard not detected"
boot_delay

sleep 1

# Clear screen for the welcome message
clear

# Full screen welcome with ASCII art
echo "$fg[cyan]"
cat << 'EOF'
__/\\\\\\\\\\\__/\\\\\\\\\\\\\\\__/\\\\\\\\\\\\\\\____/\\\\\\\\\______/\\\\____________/\\\\____/\\\\\\\\\_____        
 _\/////\\\///__\///////\\\/////__\/\\\///////////___/\\\///////\\\___\/\\\\\\________/\\\\\\__/\\\///////\\\___       
  _____\/\\\___________\/\\\_______\/\\\_____________\/\\\_____\/\\\___\/\\\//\\\____/\\\//\\\_\///______\//\\\__      
   _____\/\\\___________\/\\\_______\/\\\\\\\\\\\_____\/\\\\\\\\\\\/____\/\\\\///\\\/\\\/_\/\\\___________/\\\/___     
    _____\/\\\___________\/\\\_______\/\\\///////______\/\\\//////\\\____\/\\\__\///\\\/___\/\\\________/\\\//_____    
     _____\/\\\___________\/\\\_______\/\\\_____________\/\\\____\//\\\___\/\\\____\///_____\/\\\_____/\\\//________   
      _____\/\\\___________\/\\\_______\/\\\_____________\/\\\_____\//\\\__\/\\\_____________\/\\\___/\\\/___________  
       __/\\\\\\\\\\\_______\/\\\_______\/\\\\\\\\\\\\\\\_\/\\\______\//\\\_\/\\\_____________\/\\\__/\\\\\\\\\\\\\\\_ 
        _\///////////________\///________\///////////////__\///________\///__\///______________\///__\///////////////__
EOF
echo "$reset_color"

sleep 2

# Welcome message
echo "\n$fg[green]"
typewriter "CONSCIOUSNESS INTERFACE SYNCHRONIZED" 0.03
echo "$reset_color"

echo "\n$fg[yellow]System Status: ████████████ OPTIMAL$reset_color"
echo "$fg[blue]Neural Network: ████████████ CONNECTED$reset_color"  
echo "$fg[magenta]User Identity: ████████████ $USER_NAME@$HOST_NAME$reset_color"
echo "$fg[cyan]Security Level: ████████████ MAXIMUM$reset_color"

sleep 1

echo "\n$fg[red]"
cat << 'EOF'
 █████   ███   █████ ██████████ █████         █████████     ███████    ██████   ██████ ██████████    ███████████    █████████     █████████  █████   ████    ███████████     ███████     █████████   █████████ 
░░███   ░███  ░░███ ░░███░░░░░█░░███         ███░░░░░███  ███░░░░░███ ░░██████ ██████ ░░███░░░░░█   ░░███░░░░░███  ███░░░░░███   ███░░░░░███░░███   ███░    ░░███░░░░░███  ███░░░░░███  ███░░░░░███ ███░░░░░███
 ░███   ░███   ░███  ░███  █ ░  ░███        ███     ░░░  ███     ░░███ ░███░█████░███  ░███  █ ░     ░███    ░███ ░███    ░███  ███     ░░░  ░███  ███       ░███    ░███ ███     ░░███░███    ░░░ ░███    ░░░ 
 ░███   ░███   ░███  ░██████    ░███       ░███         ░███      ░███ ░███░░███ ░███  ░██████       ░██████████  ░███████████ ░███          ░███████        ░██████████ ░███      ░███░░█████████ ░░█████████ 
 ░░███  █████  ███   ░███░░█    ░███       ░███         ░███      ░███ ░███ ░░░  ░███  ░███░░█       ░███░░░░░███ ░███░░░░░███ ░███          ░███░░███       ░███░░░░░███░███      ░███ ░░░░░░░░███ ░░░░░░░░███
  ░░░█████░█████░    ░███ ░   █ ░███      █░░███     ███░░███     ███  ░███      ░███  ░███ ░   █    ░███    ░███ ░███    ░███ ░░███     ███ ░███ ░░███      ░███    ░███░░███     ███  ███    ░███ ███    ░███
    ░░███ ░░███      ██████████ ███████████ ░░█████████  ░░░███████░   █████     █████ ██████████    ███████████  █████   █████ ░░█████████  █████ ░░████    ███████████  ░░░███████░  ░░█████████ ░░█████████ 
     ░░░   ░░░      ░░░░░░░░░░ ░░░░░░░░░░░   ░░░░░░░░░     ░░░░░░░    ░░░░░     ░░░░░ ░░░░░░░░░░    ░░░░░░░░░░░  ░░░░░   ░░░░░   ░░░░░░░░░  ░░░░░   ░░░░    ░░░░░░░░░░░     ░░░░░░░     ░░░░░░░░░   ░░░░░░░░░  
                                                                                                                                                                                                               
                                                                                                                                                                                                               
                                                                                                                                                                                                               
EOF
echo "$reset_color"

sleep 2

# Final status
echo "\n$fg[cyan]█ System ready for neural interface operations$reset_color"
echo "$fg[cyan]█ All consciousness pathways operational$reset_color"
echo "$fg[cyan]█ Awaiting your commands...$reset_color\n"

# Return to normal prompt
echo "$fg[white]Ready for input.$reset_color"

fastfetch

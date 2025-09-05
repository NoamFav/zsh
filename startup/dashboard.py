#!/usr/bin/env python3
"""
Enhanced Horizontal Dashboard using Rich
A comprehensive system overview with improved error handling, caching, and features
"""

import subprocess
import json
import os
import re
import shutil
import psutil
import time
from datetime import datetime, timedelta
from pathlib import Path
from typing import Dict, List, Tuple, Optional, Any
from dataclasses import dataclass
from concurrent.futures import ThreadPoolExecutor, as_completed
import threading

from rich.console import Console
from rich.columns import Columns
from rich.panel import Panel
from rich.table import Table
from rich.layout import Layout
from rich import box
from rich.text import Text
from rich.align import Align
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.live import Live
from rich.tree import Tree
from rich.bar import Bar

console = Console()

# Global cache for expensive operations
_cache: Dict[str, Tuple[Any, float]] = {}
_cache_ttl = 30  # Cache TTL in seconds


@dataclass
class SystemMetrics:
    """System metrics data class"""

    cpu_percent: float
    memory_used: float
    memory_total: float
    disk_used: float
    disk_total: float
    uptime: str
    load_avg: List[float]
    network_io: Dict[str, int]


def get_cached_or_compute(key: str, compute_func, ttl: int = None) -> Any:
    """Get cached result or compute and cache it"""
    global _cache, _cache_ttl
    current_time = time.time()
    cache_ttl = ttl or _cache_ttl

    if key in _cache:
        value, timestamp = _cache[key]
        if current_time - timestamp < cache_ttl:
            return value

    result = compute_func()
    _cache[key] = (result, current_time)
    return result


def run_command(cmd: str, timeout: int = 5, shell: bool = True) -> Tuple[str, bool]:
    """Run a command with improved error handling and timeout"""
    try:
        result = subprocess.run(
            cmd,
            shell=shell,
            capture_output=True,
            text=True,
            timeout=timeout,
            check=False,
        )
        return result.stdout.strip(), result.returncode == 0
    except subprocess.TimeoutExpired:
        return f"Command timed out after {timeout}s", False
    except subprocess.CalledProcessError as e:
        return f"Command failed: {e}", False
    except Exception as e:
        return f"Error: {e}", False


def run_command_async(cmd: str, timeout: int = 5) -> Tuple[str, str, bool]:
    """Run command asynchronously and return cmd, output, success"""
    output, success = run_command(cmd, timeout)
    return cmd, output, success


def get_system_metrics() -> SystemMetrics:
    """Get comprehensive system metrics using psutil"""

    def compute_metrics():
        try:
            # CPU and memory
            cpu_percent = psutil.cpu_percent(interval=0.1)
            memory = psutil.virtual_memory()

            # Disk usage for root
            disk = psutil.disk_usage("/")

            # System uptime
            boot_time = psutil.boot_time()
            uptime_seconds = time.time() - boot_time
            uptime_str = str(timedelta(seconds=int(uptime_seconds)))

            # Load average (Unix-like systems)
            try:
                load_avg = list(os.getloadavg())
            except (OSError, AttributeError):
                load_avg = [0.0, 0.0, 0.0]

            # Network I/O
            try:
                net_io = psutil.net_io_counters()
                network_io = {
                    "bytes_sent": net_io.bytes_sent,
                    "bytes_recv": net_io.bytes_recv,
                    "packets_sent": net_io.packets_sent,
                    "packets_recv": net_io.packets_recv,
                }
            except Exception:
                network_io = {}

            return SystemMetrics(
                cpu_percent=cpu_percent,
                memory_used=memory.used,
                memory_total=memory.total,
                disk_used=disk.used,
                disk_total=disk.total,
                uptime=uptime_str,
                load_avg=load_avg,
                network_io=network_io,
            )
        except Exception as e:
            # Fallback metrics
            return SystemMetrics(
                cpu_percent=0.0,
                memory_used=0,
                memory_total=1,
                disk_used=0,
                disk_total=1,
                uptime="Unknown",
                load_avg=[0.0, 0.0, 0.0],
                network_io={},
            )

    return get_cached_or_compute("system_metrics", compute_metrics, ttl=2)


def format_bytes(bytes_value: int) -> str:
    """Format bytes into human readable format"""
    for unit in ["B", "KB", "MB", "GB", "TB"]:
        if bytes_value < 1024.0:
            return f"{bytes_value:.1f} {unit}"
        bytes_value /= 1024.0
    return f"{bytes_value:.1f} PB"


def get_system_info() -> Layout:
    """Get enhanced system information panel"""
    metrics = get_system_metrics()

    # System info table
    info_table = Table(show_header=False, box=box.SIMPLE, padding=(0, 1))
    info_table.add_column("Key", style="cyan", no_wrap=True, width=12)
    info_table.add_column("Value", style="white")

    # Get basic system info
    username = os.getenv("USER", "unknown")
    current_time = datetime.now().strftime("%A, %B %d %Y - %H:%M:%S")

    # Try fastfetch first, then fallback
    def get_system_details():
        fastfetch_output, success = run_command("fastfetch --pipe", timeout=3)

        if success and fastfetch_output:
            system_info = {}
            for line in fastfetch_output.split("\n")[:12]:
                if ":" in line and line.strip():
                    key, value = line.split(":", 1)
                    system_info[key.strip()] = value.strip()
            return system_info
        else:
            # Enhanced fallback
            info = {}

            # OS Detection
            if shutil.which("sw_vers"):  # macOS
                os_name, _ = run_command("sw_vers -productName")
                os_version, _ = run_command("sw_vers -productVersion")
                info["OS"] = f"{os_name} {os_version}"

                # Mac hardware info
                model, _ = run_command(
                    "system_profiler SPHardwareDataType | grep 'Model Name' | cut -d: -f2"
                )
                if model:
                    info["Host"] = model.strip()

                cpu_info, _ = run_command("sysctl -n machdep.cpu.brand_string")
                if cpu_info:
                    info["CPU"] = (
                        cpu_info[:40] + "..." if len(cpu_info) > 40 else cpu_info
                    )

            elif shutil.which("lsb_release"):  # Linux
                os_info, _ = run_command("lsb_release -d | cut -f2")
                info["OS"] = os_info

                cpu_info, _ = run_command("lscpu | grep 'Model name' | cut -d: -f2")
                if cpu_info:
                    info["CPU"] = cpu_info.strip()[:40]

                hostname, _ = run_command("hostname")
                info["Host"] = hostname

            # Shell and Terminal
            info["Shell"] = os.getenv("SHELL", "unknown").split("/")[-1]
            info["Terminal"] = os.getenv("TERM_PROGRAM", os.getenv("TERM", "unknown"))

            return info

    system_details = get_cached_or_compute(
        "system_details", get_system_details, ttl=300
    )

    # Add system details to table
    for key, value in list(system_details.items())[:8]:
        if value and value != "unknown":
            info_table.add_row(key, value)

    # Add uptime
    info_table.add_row("Uptime", metrics.uptime)

    # Performance metrics table
    perf_table = Table(show_header=False, box=box.SIMPLE, padding=(0, 1))
    perf_table.add_column("Metric", style="yellow", no_wrap=True, width=12)
    perf_table.add_column("Value", style="white")
    perf_table.add_column("Bar", style="white", width=10)

    # CPU
    cpu_bar = "█" * int(metrics.cpu_percent / 10) + "░" * (
        10 - int(metrics.cpu_percent / 10)
    )
    perf_table.add_row(
        "CPU",
        f"{metrics.cpu_percent:.1f}%",
        f"[{'red' if metrics.cpu_percent > 80 else 'yellow' if metrics.cpu_percent > 50 else 'green'}]{cpu_bar}[/]",
    )

    # Memory
    mem_percent = (metrics.memory_used / metrics.memory_total) * 100
    mem_bar = "█" * int(mem_percent / 10) + "░" * (10 - int(mem_percent / 10))
    perf_table.add_row(
        "Memory",
        f"{format_bytes(metrics.memory_used)}/{format_bytes(metrics.memory_total)}",
        f"[{'red' if mem_percent > 80 else 'yellow' if mem_percent > 60 else 'green'}]{mem_bar}[/]",
    )

    # Disk
    disk_percent = (metrics.disk_used / metrics.disk_total) * 100
    disk_bar = "█" * int(disk_percent / 10) + "░" * (10 - int(disk_percent / 10))
    perf_table.add_row(
        "Disk",
        f"{format_bytes(metrics.disk_used)}/{format_bytes(metrics.disk_total)}",
        f"[{'red' if disk_percent > 90 else 'yellow' if disk_percent > 70 else 'green'}]{disk_bar}[/]",
    )

    # Load average
    load_color = (
        "red"
        if metrics.load_avg[0] > 2
        else "yellow" if metrics.load_avg[0] > 1 else "green"
    )
    perf_table.add_row(
        "Load",
        f"{metrics.load_avg[0]:.2f} {metrics.load_avg[1]:.2f} {metrics.load_avg[2]:.2f}",
        f"[{load_color}]{'█' * min(10, int(metrics.load_avg[0] * 3))}[/]",
    )

    # Create header
    header = Text()
    header.append(f"Welcome back, ", style="bold white")
    header.append(f"{username}", style="bold green")
    header.append("!\n", style="bold white")
    header.append(f"{current_time}", style="dim white")

    header_panel = Panel(Align.center(header), box=box.ROUNDED, border_style="green")

    # System info panel
    info_panel = Panel(
        info_table,
        title="[bold blue]System Info[/bold blue]",
        border_style="blue",
        box=box.ROUNDED,
    )

    # Performance panel
    perf_panel = Panel(
        perf_table,
        title="[bold yellow]Performance[/bold yellow]",
        border_style="yellow",
        box=box.ROUNDED,
    )

    return Layout(
        renderable=Columns([header_panel, info_panel, perf_panel], equal=True)
    )


def get_git_status() -> Panel:
    """Get enhanced git repositories status with parallel processing"""

    def scan_git_repos():
        """Scan for git repositories"""
        repos = []

        # Common paths to check
        search_paths = [
            Path.home() / "Neoware",
            Path.home() / "Projects",
            Path.home() / "Code",
            Path.home() / "Development",
            Path.home() / ".config",
            Path.home() / "Documents" / "GitHub",
            Path.cwd(),  # Current directory
        ]

        for base_path in search_paths:
            if base_path.exists() and base_path.is_dir():
                try:
                    # Find git repos (limit depth to avoid performance issues)
                    for item in base_path.iterdir():
                        if item.is_dir():
                            git_dir = item / ".git"
                            if git_dir.exists():
                                repos.append(item)
                            # Check one level deeper for workspace-style repos
                            elif item.name not in {
                                ".git",
                                ".svn",
                                "node_modules",
                                "__pycache__",
                            }:
                                try:
                                    for subitem in item.iterdir():
                                        if (
                                            subitem.is_dir()
                                            and (subitem / ".git").exists()
                                        ):
                                            repos.append(subitem)
                                except (PermissionError, OSError):
                                    continue
                except (PermissionError, OSError):
                    continue

        return list(set(repos))[:25]  # Remove duplicates, limit to 25

    def check_repo_status(repo_path: Path) -> Tuple[str, str, str]:
        """Check status of a single repo"""
        repo_name = repo_path.name

        # Get git status
        git_status, success = run_command(
            f'cd "{repo_path}" && git status --porcelain', timeout=3
        )

        if not success:
            return repo_name, "❌ error", "red"

        # Check for uncommitted changes
        if git_status.strip():
            # Count changes
            lines = git_status.strip().split("\n")
            modified = sum(
                1 for line in lines if line.startswith(" M") or line.startswith("MM")
            )
            added = sum(1 for line in lines if line.startswith("A"))
            deleted = sum(1 for line in lines if line.startswith(" D"))
            untracked = sum(1 for line in lines if line.startswith("??"))

            status_parts = []
            if modified:
                status_parts.append(f"~{modified}")
            if added:
                status_parts.append(f"+{added}")
            if deleted:
                status_parts.append(f"-{deleted}")
            if untracked:
                status_parts.append(f"?{untracked}")

            return repo_name, f"🔴 {' '.join(status_parts)}", "red"

        # Check if ahead/behind remote
        remote_status, success = run_command(
            f'cd "{repo_path}" && git status -b --porcelain', timeout=3
        )
        if success and remote_status:
            first_line = remote_status.split("\n")[0]
            if "[ahead" in first_line:
                return repo_name, "🔵 ahead", "blue"
            elif "[behind" in first_line:
                return repo_name, "🟡 behind", "yellow"

        return repo_name, "✅ clean", "green"

    repos = get_cached_or_compute("git_repos", scan_git_repos, ttl=120)

    if not repos:
        table = Table(show_header=False, box=box.SIMPLE)
        table.add_column("Message", style="dim")
        table.add_row("No git repositories found")
        return Panel(
            table,
            title="[bold green]📂 Git Repositories[/bold green]",
            border_style="green",
            box=box.ROUNDED,
        )

    # Check repos in parallel
    table = Table(show_header=True, box=box.SIMPLE, padding=(0, 1))
    table.add_column("Repository", style="cyan", no_wrap=True, max_width=30)
    table.add_column("Status", style="white", no_wrap=True)
    table.add_column("Path", style="dim", max_width=40)

    status_counts = {"clean": 0, "dirty": 0, "ahead": 0, "behind": 0, "error": 0}

    # Use ThreadPoolExecutor for parallel status checks
    with ThreadPoolExecutor(max_workers=5) as executor:
        future_to_repo = {
            executor.submit(check_repo_status, repo): repo for repo in repos
        }

        results = []
        for future in as_completed(future_to_repo, timeout=10):
            try:
                repo_name, status, color = future.result()
                results.append((repo_name, status, color, future_to_repo[future]))
            except Exception:
                repo = future_to_repo[future]
                results.append((repo.name, "❌ error", "red", repo))

    # Sort results by name and add to table
    results.sort(key=lambda x: x[0].lower())

    for repo_name, status, color, repo_path in results:
        # Update counts
        if "clean" in status:
            status_counts["clean"] += 1
        elif "error" in status:
            status_counts["error"] += 1
        elif "ahead" in status:
            status_counts["ahead"] += 1
        elif "behind" in status:
            status_counts["behind"] += 1
        else:
            status_counts["dirty"] += 1

        table.add_row(repo_name, f"[{color}]{status}[/{color}]", str(repo_path.parent))

    # Add summary
    if results:
        table.add_row("", "", "")
        summary_parts = []
        if status_counts["clean"]:
            summary_parts.append(f"[green]{status_counts['clean']} clean[/green]")
        if status_counts["dirty"]:
            summary_parts.append(f"[red]{status_counts['dirty']} dirty[/red]")
        if status_counts["ahead"]:
            summary_parts.append(f"[blue]{status_counts['ahead']} ahead[/blue]")
        if status_counts["behind"]:
            summary_parts.append(f"[yellow]{status_counts['behind']} behind[/yellow]")
        if status_counts["error"]:
            summary_parts.append(f"[red]{status_counts['error']} errors[/red]")

        table.add_row("[bold]Summary[/bold]", " | ".join(summary_parts), "")

    return Panel(
        table,
        title="[bold green]📂 Git Repositories[/bold green]",
        border_style="green",
        box=box.ROUNDED,
    )


def get_package_managers_status() -> Panel:
    """Get status for multiple package managers"""
    table = Table(show_header=True, box=box.SIMPLE, padding=(0, 1))
    table.add_column("Manager", style="yellow", no_wrap=True)
    table.add_column("Packages", style="white")
    table.add_column("Outdated", style="white")
    table.add_column("Details", style="dim")

    managers = []

    # Homebrew
    if shutil.which("brew"):

        def get_brew_info():
            outdated_output, success = run_command("brew outdated", timeout=10)
            outdated_count = (
                len([l for l in outdated_output.split("\n") if l.strip()])
                if success
                else 0
            )

            total_output, success = run_command("brew list | wc -l")
            total_count = total_output.strip() if success else "?"

            details = ""
            if outdated_count > 0:
                first_outdated = (
                    outdated_output.split("\n")[0] if outdated_output else ""
                )
                if first_outdated:
                    details = f"e.g., {first_outdated.split()[0]}"

            return "🍺 Homebrew", total_count, outdated_count, details

        managers.append(("brew", get_brew_info))

    # npm (if available)
    if shutil.which("npm"):

        def get_npm_info():
            global_output, success = run_command(
                "npm list -g --depth=0 2>/dev/null | wc -l"
            )
            global_count = (
                int(global_output.strip()) - 1
                if success and global_output.isdigit()
                else "?"
            )

            outdated_output, success = run_command(
                "npm outdated -g --depth=0 2>/dev/null | wc -l"
            )
            outdated_count = (
                int(outdated_output.strip()) - 1
                if success and outdated_output.isdigit()
                else 0
            )

            return "📦 npm", f"{global_count} global", outdated_count, ""

        managers.append(("npm", get_npm_info))

    # pip
    if shutil.which("pip"):

        def get_pip_info():
            list_output, success = run_command("pip list | wc -l")
            total_count = (
                int(list_output.strip()) - 2
                if success and list_output.strip().isdigit()
                else "?"
            )

            outdated_output, success = run_command("pip list --outdated | wc -l")
            outdated_count = (
                int(outdated_output.strip()) - 2
                if success and outdated_output.strip().isdigit()
                else 0
            )

            return "🐍 pip", total_count, max(0, outdated_count), ""

        managers.append(("pip", get_pip_info))

    # Run package manager checks in parallel
    if managers:
        with ThreadPoolExecutor(max_workers=3) as executor:
            futures = [executor.submit(func) for name, func in managers]

            for future in as_completed(futures, timeout=15):
                try:
                    manager, total, outdated, details = future.result()
                    outdated_color = "red" if outdated > 0 else "green"
                    table.add_row(
                        manager,
                        str(total),
                        f"[{outdated_color}]{outdated}[/{outdated_color}]",
                        details,
                    )
                except Exception as e:
                    table.add_row("❌ Error", str(e)[:30], "", "")
    else:
        table.add_row("No package managers found", "", "", "")

    return Panel(
        table,
        title="[bold yellow]📦 Package Managers[/bold yellow]",
        border_style="yellow",
        box=box.ROUNDED,
    )


def get_enhanced_tips_panel() -> Panel:
    """Get enhanced tips with system-specific shortcuts"""
    tips_text = Text()

    # Dynamic tips based on available tools
    tips = []

    if shutil.which("zsh"):
        tips.append(("zc", "config"))
    if shutil.which("lazygit"):
        tips.append(("lg", "lazygit"))
    if shutil.which("yazi"):
        tips.append(("y", "yazi"))
    if shutil.which("brew"):
        tips.append(("brew upgrade", "update packages"))
    if shutil.which("nvim"):
        tips.append(("nvim", "editor"))
    if shutil.which("htop"):
        tips.append(("htop", "system monitor"))
    if shutil.which("docker"):
        tips.append(("docker ps", "containers"))

    # Add custom tips
    tips.extend(
        [("Ctrl+R", "history search"), ("Alt+.", "last arg"), ("!!", "last cmd")]
    )

    # Format tips
    tips_text.append("💡 Quick Tips: ", style="bold magenta")

    for i, (cmd, desc) in enumerate(tips[:6]):  # Limit to 6 tips
        if i > 0:
            tips_text.append(" | ", style="dim white")
        tips_text.append(cmd, style="cyan bold")
        tips_text.append(f"→{desc}", style="white")

    return Panel(
        Align.center(tips_text),
        title="[dim]Tips[/dim]",
        border_style="magenta",
        box=box.ROUNDED,
    )


def main():
    """Enhanced main dashboard function"""
    console.clear()

    try:
        # Create the layout with dynamic sizing
        layout = Layout()

        # Determine terminal size for responsive design
        terminal_size = console.size
        header_size = 8 if terminal_size.height > 30 else 6
        footer_size = 3
        main_size = max(15, terminal_size.height - header_size - footer_size - 2)

        layout.split_column(
            Layout(name="header", size=header_size),
            Layout(name="main", size=main_size),
            Layout(name="footer", size=footer_size),
        )

        # Split main section based on terminal width
        if terminal_size.width > 120:
            layout["main"].split_row(
                Layout(name="git", ratio=3), Layout(name="packages", ratio=2)
            )
        else:
            layout["main"].split_column(
                Layout(name="git", ratio=2), Layout(name="packages", ratio=1)
            )

        # Show loading message while gathering data
        with console.status("[bold green]Loading dashboard data...", spinner="dots"):
            # Load content for each section
            layout["header"].update(get_system_info())
            layout["git"].update(get_git_status())
            layout["packages"].update(get_package_managers_status())
            layout["footer"].update(get_enhanced_tips_panel())

        console.print(layout)

        # Add refresh hint
        console.print(
            f"\n[dim]Last updated: {datetime.now().strftime('%H:%M:%S')} | Press Ctrl+C to exit | Run again to refresh[/dim]"
        )

    except KeyboardInterrupt:
        console.print("\n[yellow]Dashboard interrupted by user[/yellow]")
    except Exception as e:
        console.print(f"\n[red]Error: {e}[/red]")
        console.print(
            "[dim]Please check your system configuration and try again.[/dim]"
        )


if __name__ == "__main__":
    main()

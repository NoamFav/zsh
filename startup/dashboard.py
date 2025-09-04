#!/usr/bin/env python3
"""
Horizontal Dashboard using Rich
Replacement for the vertical zs command output
"""

import subprocess
import json
import os
import re
from datetime import datetime
from pathlib import Path
from rich.console import Console
from rich.columns import Columns
from rich.panel import Panel
from rich.table import Table
from rich.layout import Layout
from rich import box
from rich.text import Text
from rich.align import Align

console = Console()


def run_command(cmd, shell=True):
    """Run a command and return its output"""
    try:
        result = subprocess.run(
            cmd, shell=shell, capture_output=True, text=True, timeout=10
        )
        return result.stdout.strip(), result.returncode == 0
    except subprocess.TimeoutExpired:
        return "", False
    except Exception:
        return "", False


def get_system_info():
    """Get system information panel"""
    table = Table(show_header=False, box=box.SIMPLE, padding=(0, 1))
    table.add_column("Key", style="cyan", no_wrap=True)
    table.add_column("Value", style="white")

    # Get current user and time
    username = os.getenv("USER", "unknown")
    current_time = datetime.now().strftime("%A, %B %d %Y - %H:%M:%S")

    # Try to get fastfetch output first, fall back to individual commands
    fastfetch_output, success = run_command("fastfetch --pipe")

    if success and fastfetch_output:
        # Parse fastfetch output
        lines = fastfetch_output.split("\n")
        for line in lines[:15]:  # Limit to prevent overflow
            if ":" in line and line.strip():
                key, value = line.split(":", 1)
                key = key.strip()
                value = value.strip()

                # Skip empty values
                if value:
                    table.add_row(key, value)
    else:
        # Fallback to manual system info gathering
        # OS info
        os_info, _ = run_command("sw_vers -productName && sw_vers -productVersion")
        if os_info:
            table.add_row("OS", os_info.replace("\n", " "))

        # Host info
        host_info, _ = run_command(
            "system_profiler SPHardwareDataType | grep 'Model Name' | cut -d: -f2"
        )
        if host_info:
            table.add_row("Host", host_info.strip())

        # Uptime
        uptime_info, _ = run_command(
            "uptime | sed 's/.*up \\(.*\\), [0-9]* user.*/\\1/'"
        )
        if uptime_info:
            table.add_row("Uptime", uptime_info)

        # CPU info
        cpu_info, _ = run_command("sysctl -n machdep.cpu.brand_string")
        if cpu_info:
            table.add_row("CPU", cpu_info)

        # Memory info
        mem_info, _ = run_command("vm_stat | head -4")
        if mem_info:
            table.add_row("Memory", "See Activity Monitor")

        # Shell
        shell = os.getenv("SHELL", "unknown").split("/")[-1]
        table.add_row("Shell", shell)

        # Terminal
        term = os.getenv("TERM_PROGRAM", "unknown")
        table.add_row("Terminal", term)

    # Create header text
    header = Text(f"Welcome back, {username}!\n{current_time}", style="bold green")
    header_panel = Panel(Align.center(header), box=box.ROUNDED, border_style="green")

    # Combine header and system info
    system_panel = Panel(
        table,
        title="[bold blue]System Info[/bold blue]",
        border_style="blue",
        box=box.ROUNDED,
    )

    return Layout(renderable=Columns([header_panel, system_panel], equal=True))


def get_git_status():
    """Get git repositories status panel"""
    table = Table(show_header=True, box=box.SIMPLE, padding=(0, 1))
    table.add_column("Repository", style="cyan", no_wrap=True, max_width=25)
    table.add_column("Status", style="white", no_wrap=True)

    # Check if gitcheck command exists
    gitcheck_output, success = run_command("which gitcheck")

    if success:
        # Use existing gitcheck command
        git_output, success = run_command("gitcheck")
        if success:
            lines = git_output.split("\n")
            clean_count = 0
            dirty_count = 0

            for line in lines:
                if line.strip():
                    # Parse the gitcheck output format
                    if "✅ clean" in line:
                        repo_path = line.split("✅")[0].strip()
                        repo_name = (
                            repo_path.split("/")[-1] if "/" in repo_path else repo_path
                        )
                        table.add_row(repo_name, "[green]✅ clean[/green]")
                        clean_count += 1
                    elif "🔴" in line and "uncommitted changes" in line:
                        repo_path = line.split("🔴")[0].strip()
                        repo_name = (
                            repo_path.split("/")[-1] if "/" in repo_path else repo_path
                        )
                        table.add_row(repo_name, "[red]🔴 dirty[/red]")
                        dirty_count += 1

            # Add summary row
            table.add_row("", "")
            table.add_row(
                "[bold]Summary[/bold]",
                f"[green]{clean_count} clean[/green] | [red]{dirty_count} dirty[/red]",
            )
    else:
        # Fallback: check common git directories
        neoware_path = Path.home() / "Neoware"
        config_paths = [
            Path.home() / ".config" / "nvim",
            Path.home() / ".config" / "zsh",
        ]

        all_paths = []
        if neoware_path.exists():
            all_paths.extend(
                [
                    p
                    for p in neoware_path.iterdir()
                    if p.is_dir() and (p / ".git").exists()
                ]
            )

        for config_path in config_paths:
            if config_path.exists() and (config_path / ".git").exists():
                all_paths.append(config_path)

        clean_count = 0
        dirty_count = 0

        for repo_path in sorted(all_paths)[
            :20
        ]:  # Limit to 20 repos to prevent overflow
            repo_name = repo_path.name

            # Check git status
            git_status, success = run_command(
                f'cd "{repo_path}" && git status --porcelain'
            )

            if success:
                if git_status.strip():
                    table.add_row(repo_name, "[red]🔴 dirty[/red]")
                    dirty_count += 1
                else:
                    table.add_row(repo_name, "[green]✅ clean[/green]")
                    clean_count += 1
            else:
                table.add_row(repo_name, "[yellow]? unknown[/yellow]")

        # Add summary
        if all_paths:
            table.add_row("", "")
            table.add_row(
                "[bold]Summary[/bold]",
                f"[green]{clean_count} clean[/green] | [red]{dirty_count} dirty[/red]",
            )

    return Panel(
        table,
        title="[bold green]📂 Git Repositories[/bold green]",
        border_style="green",
        box=box.ROUNDED,
    )


def get_brew_status():
    """Get homebrew status panel"""
    table = Table(show_header=False, box=box.SIMPLE, padding=(0, 1))
    table.add_column("Info", style="yellow")
    table.add_column("Value", style="white")

    # Check for outdated packages
    outdated_output, success = run_command("brew outdated")
    outdated_count = 0
    if success:
        outdated_count = len(
            [line for line in outdated_output.split("\n") if line.strip()]
        )

    table.add_row("Outdated packages", str(outdated_count))

    # Get total package count
    list_output, success = run_command("brew list | wc -l")
    if success:
        table.add_row("Total packages", list_output.strip())

    # Get cask count
    cask_output, success = run_command("brew list --cask | wc -l")
    if success:
        table.add_row("Casks installed", cask_output.strip())

    # Get formulae count
    formulae_output, success = run_command("brew list --formula | wc -l")
    if success:
        table.add_row("Formulae installed", formulae_output.strip())

    # Add some recent outdated packages if any
    if outdated_count > 0:
        table.add_row("", "")
        table.add_row("[bold]Recent outdated:[/bold]", "")
        outdated_lines = outdated_output.split("\n")[:3]  # Show first 3
        for line in outdated_lines:
            if line.strip():
                package = line.split()[0] if line.split() else line
                table.add_row("", f"• {package}")

    return Panel(
        table,
        title="[bold yellow]🍺 Homebrew[/bold yellow]",
        border_style="yellow",
        box=box.ROUNDED,
    )


def get_tips_panel():
    """Get tips and shortcuts panel"""
    tips_text = Text()
    tips_text.append("💡 Tips: ", style="bold")
    tips_text.append("zc", style="cyan")
    tips_text.append("→config | ", style="white")
    tips_text.append("lg", style="cyan")
    tips_text.append("→lazygit | ", style="white")
    tips_text.append("y", style="cyan")
    tips_text.append("→yazi | ", style="white")
    tips_text.append("hb_search", style="cyan")
    tips_text.append("→brew helper", style="white")

    return Panel(Align.center(tips_text), border_style="magenta", box=box.ROUNDED)


def main():
    """Main dashboard function"""
    console.clear()

    # Create the layout
    layout = Layout()

    # Top section with system info
    layout.split_column(
        Layout(name="header", size=6),
        Layout(name="main", size=15),
        Layout(name="footer", size=3),
    )

    # Split main section into columns
    layout["main"].split_row(Layout(name="git", ratio=2), Layout(name="brew", ratio=1))

    # Add content to each section
    layout["header"].update(get_system_info())
    layout["git"].update(get_git_status())
    layout["brew"].update(get_brew_status())
    layout["footer"].update(get_tips_panel())

    console.print(layout)


if __name__ == "__main__":
    main()

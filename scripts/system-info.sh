#!/bin/bash

# Capture system information for better reproducibility

DOTFILES_DIR="$HOME/dotfiles"
INFO_DIR="$DOTFILES_DIR/system-info"

mkdir -p "$INFO_DIR"

echo "Capturing system information..."

# Basic system info
{
    echo "# System Information"
    echo "Generated on: $(date)"
    echo ""
    echo "## Hardware"
    echo "- Hostname: $(cat /etc/hostname 2>/dev/null || echo 'unknown')"
    echo "- Kernel: $(uname -r)"
    echo "- Architecture: $(uname -m)"
    echo "- CPU: $(lscpu | grep 'Model name' | cut -d: -f2 | xargs)"
    echo "- Memory: $(free -h | awk '/^Mem:/ {print $2}')"
    echo ""
    echo "## Graphics"
    lspci | grep -E 'VGA|3D|Display' | sed 's/^/- /'
    echo ""
} > "$INFO_DIR/system-info.md"

# Display configuration
if command -v hyprctl &> /dev/null; then
    hyprctl monitors > "$INFO_DIR/monitors.txt" 2>/dev/null
fi

# Audio devices
pactl list sinks > "$INFO_DIR/audio-sinks.txt" 2>/dev/null

# Network interfaces
ip addr > "$INFO_DIR/network-interfaces.txt"

# Services
systemctl list-unit-files --state=enabled --user > "$INFO_DIR/user-services.txt"

# Fonts
fc-list : family | sort | uniq > "$INFO_DIR/installed-fonts.txt"

echo "System information saved!"
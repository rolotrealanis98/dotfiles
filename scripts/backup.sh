#!/bin/bash

# Backup script for dotfiles
# This script backs up your current configuration files to the dotfiles repository

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo "Starting configuration backup..."

# Create necessary directories
mkdir -p "$DOTFILES_DIR/.config"

# Define configurations to backup
configs=(
    "hypr"
    "waybar"
    "rofi"
    "kitty"
    "alacritty"
    "nvim"
    "zsh"
    "fish"
    "gtk-3.0"
    "gtk-4.0"
    "fontconfig"
    "dunst"
    "mako"
    "swaylock"
    "wlogout"
    "wofi"
)

# Backup each configuration
for config in "${configs[@]}"; do
    if [ -d "$CONFIG_DIR/$config" ] || [ -f "$CONFIG_DIR/$config" ]; then
        echo "Backing up $config..."
        cp -r "$CONFIG_DIR/$config" "$DOTFILES_DIR/.config/"
    fi
done

# Backup home directory dotfiles
home_configs=(
    ".bashrc"
    ".zshrc"
    ".gitconfig"
    ".xinitrc"
    ".Xresources"
    ".profile"
)

for config in "${home_configs[@]}"; do
    if [ -f "$HOME/$config" ]; then
        echo "Backing up $config..."
        cp "$HOME/$config" "$DOTFILES_DIR/"
    fi
done

# Generate package lists
echo "Generating package lists..."
pacman -Qqe > "$DOTFILES_DIR/packages/pacman-packages.txt"
pacman -Qqm > "$DOTFILES_DIR/packages/aur-packages.txt"

# If using paru or yay
if command -v paru &> /dev/null; then
    paru -Qqm > "$DOTFILES_DIR/packages/aur-packages.txt"
elif command -v yay &> /dev/null; then
    yay -Qqm > "$DOTFILES_DIR/packages/aur-packages.txt"
fi

# Backup systemd user services
if [ -d "$HOME/.config/systemd/user" ]; then
    echo "Backing up systemd user services..."
    cp -r "$HOME/.config/systemd/user" "$DOTFILES_DIR/.config/systemd/"
fi

echo "Backup complete!"
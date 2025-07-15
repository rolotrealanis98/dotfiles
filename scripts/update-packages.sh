#!/bin/bash

# Update package lists
# This script updates the package lists to reflect current system state

DOTFILES_DIR="$HOME/dotfiles"

echo "Updating package lists..."

# Create packages directory if it doesn't exist
mkdir -p "$DOTFILES_DIR/packages"

# Update pacman packages list (explicitly installed)
pacman -Qqe > "$DOTFILES_DIR/packages/pacman-packages.txt"
echo "Updated pacman packages list"

# Update AUR packages list
if command -v paru &> /dev/null; then
    paru -Qqm > "$DOTFILES_DIR/packages/aur-packages.txt"
elif command -v yay &> /dev/null; then
    yay -Qqm > "$DOTFILES_DIR/packages/aur-packages.txt"
else
    pacman -Qqm > "$DOTFILES_DIR/packages/aur-packages.txt"
fi
echo "Updated AUR packages list"

# Create a detailed package list with descriptions
echo "Generating detailed package list..."
{
    echo "# Arch Linux Package List"
    echo "# Generated on $(date)"
    echo ""
    echo "## Explicitly Installed Packages"
    echo ""
    pacman -Qei | awk '/^Name/{name=$3} /^Description/{desc=$0; sub(/^Description\s*:\s*/, "", desc); printf "- %s: %s\n", name, desc}'
} > "$DOTFILES_DIR/packages/detailed-packages.md"

echo "Package lists updated successfully!"
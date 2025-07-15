#!/bin/bash

# Install script for dotfiles
# This script sets up a new system with your configurations

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Starting dotfiles installation...${NC}"

# Check if running on Arch-based system
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}This script is designed for Arch Linux systems${NC}"
    exit 1
fi

# Install essential packages first
echo -e "${YELLOW}Installing essential packages...${NC}"
sudo pacman -S --needed base-devel git

# Install AUR helper if not present
if ! command -v paru &> /dev/null && ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}Installing paru AUR helper...${NC}"
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/paru
fi

# Determine AUR helper
if command -v paru &> /dev/null; then
    AUR_HELPER="paru"
elif command -v yay &> /dev/null; then
    AUR_HELPER="yay"
else
    echo -e "${RED}No AUR helper found${NC}"
    exit 1
fi

# Install packages from lists
echo -e "${YELLOW}Installing packages from package lists...${NC}"
if [ -f "$DOTFILES_DIR/packages/pacman-packages.txt" ]; then
    sudo pacman -S --needed - < "$DOTFILES_DIR/packages/pacman-packages.txt"
fi

if [ -f "$DOTFILES_DIR/packages/aur-packages.txt" ]; then
    $AUR_HELPER -S --needed - < "$DOTFILES_DIR/packages/aur-packages.txt"
fi

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    # If target exists and is not a symlink, back it up
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo -e "${YELLOW}Backing up existing $target to $target.bak${NC}"
        mv "$target" "$target.bak"
    fi
    
    # Remove existing symlink if it exists
    if [ -L "$target" ]; then
        rm "$target"
    fi
    
    # Create symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}Created symlink: $target -> $source${NC}"
}

# Link configurations
echo -e "${YELLOW}Creating configuration symlinks...${NC}"

# Link .config directories
for config in "$DOTFILES_DIR/.config"/*; do
    if [ -d "$config" ] || [ -f "$config" ]; then
        config_name=$(basename "$config")
        create_symlink "$config" "$CONFIG_DIR/$config_name"
    fi
done

# Link home directory dotfiles
for dotfile in "$DOTFILES_DIR"/.*; do
    if [ -f "$dotfile" ]; then
        filename=$(basename "$dotfile")
        # Skip .git, .gitignore
        if [[ "$filename" != ".git" && "$filename" != ".gitignore" && "$filename" != "." && "$filename" != ".." ]]; then
            create_symlink "$dotfile" "$HOME/$filename"
        fi
    fi
done

# Enable systemd user services if present
if [ -d "$CONFIG_DIR/systemd/user" ]; then
    echo -e "${YELLOW}Enabling systemd user services...${NC}"
    for service in "$CONFIG_DIR/systemd/user"/*.service; do
        if [ -f "$service" ]; then
            service_name=$(basename "$service")
            systemctl --user enable "$service_name"
        fi
    done
fi

# Set default shell if zsh is installed and configured
if command -v zsh &> /dev/null && [ -f "$HOME/.zshrc" ]; then
    echo -e "${YELLOW}Setting zsh as default shell...${NC}"
    chsh -s $(which zsh)
fi

# Install additional Hyprland-specific packages
echo -e "${YELLOW}Installing Hyprland ecosystem packages...${NC}"
hypr_packages=(
    "hyprland"
    "waybar"
    "rofi-wayland"
    "dunst"
    "swaylock"
    "swayidle"
    "wlogout"
    "grim"
    "slurp"
    "wl-clipboard"
    "polkit-kde-agent"
    "qt5-wayland"
    "qt6-wayland"
    "xdg-desktop-portal-hyprland"
)

sudo pacman -S --needed "${hypr_packages[@]}"

echo -e "${GREEN}Installation complete!${NC}"
echo -e "${YELLOW}Please log out and log back in for all changes to take effect.${NC}"
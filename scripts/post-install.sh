#!/bin/bash

# Post-installation setup
# Run this after install.sh to configure services and settings

echo "Running post-installation setup..."

# Enable essential services
echo "Enabling system services..."

# Network Time Protocol
sudo systemctl enable --now systemd-timesyncd

# If using bluetooth
if pacman -Qi bluez &> /dev/null; then
    sudo systemctl enable --now bluetooth
fi

# If using cups for printing
if pacman -Qi cups &> /dev/null; then
    sudo systemctl enable --now cups
fi

# Set up user directories
echo "Creating user directories..."
mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Videos ~/Projects ~/Screenshots

# Configure git
if [ ! -f ~/.gitconfig ]; then
    echo "Setting up git configuration..."
    read -p "Enter your git username: " git_name
    read -p "Enter your git email: " git_email
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
fi

# Set up screenshot directory for grim
mkdir -p ~/Screenshots
echo "Screenshots directory created at ~/Screenshots"

# Install Oh My Zsh if using zsh
if command -v zsh &> /dev/null && [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Set up default applications
echo "Setting up default applications..."
xdg-mime default firefox.desktop x-scheme-handler/http
xdg-mime default firefox.desktop x-scheme-handler/https
xdg-mime default thunar.desktop inode/directory

# Font configuration
echo "Updating font cache..."
fc-cache -fv

echo "Post-installation setup complete!"
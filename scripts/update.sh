#!/bin/bash

# Update script for dotfiles
# This script helps you sync your dotfiles to the repository

DOTFILES_DIR="$HOME/dotfiles"
CURRENT_DIR=$(pwd)

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Updating dotfiles repository...${NC}"

# Change to dotfiles directory
cd "$DOTFILES_DIR"

# Run backup script first
echo -e "${YELLOW}Running backup script...${NC}"
"$DOTFILES_DIR/scripts/backup.sh"

# Update package lists
echo -e "${YELLOW}Updating package lists...${NC}"
"$DOTFILES_DIR/scripts/update-packages.sh"

# Check git status
echo -e "${YELLOW}Checking git status...${NC}"
git status

# Ask user if they want to commit changes
echo -e "${YELLOW}Do you want to commit these changes? (y/n)${NC}"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    # Add all changes
    git add -A
    
    # Get commit message
    echo -e "${YELLOW}Enter commit message:${NC}"
    read -r commit_message
    
    # Commit changes
    git commit -m "$commit_message"
    
    echo -e "${GREEN}Changes committed!${NC}"
    
    # Ask if user wants to push
    echo -e "${YELLOW}Do you want to push to remote? (y/n)${NC}"
    read -r push_response
    
    if [[ "$push_response" =~ ^[Yy]$ ]]; then
        git push
        echo -e "${GREEN}Changes pushed to remote!${NC}"
    fi
else
    echo -e "${RED}Changes not committed.${NC}"
fi

# Return to original directory
cd "$CURRENT_DIR"

echo -e "${GREEN}Update complete!${NC}"
#!/bin/bash

# Quick update script - non-interactive version
# Usage: ./quick-update.sh "commit message"

DOTFILES_DIR="$HOME/dotfiles"
CURRENT_DIR=$(pwd)

if [ -z "$1" ]; then
    echo "Usage: $0 \"commit message\""
    exit 1
fi

cd "$DOTFILES_DIR"

# Run backup
"$DOTFILES_DIR/scripts/backup.sh"

# Update packages
"$DOTFILES_DIR/scripts/update-packages.sh"

# Git operations
git add -A
git commit -m "$1"
git push

cd "$CURRENT_DIR"

echo "Quick update complete!"
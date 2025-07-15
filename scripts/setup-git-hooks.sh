#!/bin/bash

# Set up git hooks for automatic updates

DOTFILES_DIR="$HOME/dotfiles"

# Create pre-commit hook to update package lists
cat > "$DOTFILES_DIR/.git/hooks/pre-commit" << 'EOF'
#!/bin/bash
# Auto-update package lists before commit

echo "Updating package lists..."
"$HOME/dotfiles/scripts/update-packages.sh"
git add packages/*.txt
EOF

chmod +x "$DOTFILES_DIR/.git/hooks/pre-commit"

echo "Git hooks installed!"
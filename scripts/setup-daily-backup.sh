#!/bin/bash

# Set up automatic daily backup

DOTFILES_DIR="$HOME/dotfiles"

# Create systemd user timer for daily backups
mkdir -p ~/.config/systemd/user

# Create service file
cat > ~/.config/systemd/user/dotfiles-backup.service << EOF
[Unit]
Description=Daily dotfiles backup
After=network.target

[Service]
Type=oneshot
ExecStart=$DOTFILES_DIR/scripts/quick-update.sh "Daily automatic backup"
EOF

# Create timer file
cat > ~/.config/systemd/user/dotfiles-backup.timer << EOF
[Unit]
Description=Run dotfiles backup daily
Persistent=true

[Timer]
OnCalendar=daily
RandomizedDelaySec=1h

[Install]
WantedBy=timers.target
EOF

# Enable timer
systemctl --user daemon-reload
systemctl --user enable --now dotfiles-backup.timer

echo "Daily backup timer installed and enabled!"
echo "Check status with: systemctl --user status dotfiles-backup.timer"
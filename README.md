# Arch Linux Dotfiles

Personal dotfiles for Arch Linux with Hyprland, Waybar, Rofi, and more. Designed for easy migration between machines including Asahi Linux.

## Features

- 🔄 Automatic package tracking (pacman & AUR)
- 🔗 Symlink-based configuration management
- 📊 System information capture
- 🔐 Secure secrets management
- ⏰ Optional daily automatic backups
- 🚀 Quick aliases for common tasks
- 🖥️ Machine-specific configurations

## Quick Start

### On a new machine:
```bash
git clone https://github.com/rolotrealanis98/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/install.sh
./scripts/post-install.sh  # Configure services and settings
source ~/.aliases           # Load aliases
```

### Backup current configuration:
```bash
cd ~/dotfiles
./scripts/backup.sh
```

### Update repository with changes:
```bash
cd ~/dotfiles
./scripts/update.sh
# OR for quick non-interactive update:
./scripts/quick-update.sh "Your commit message"
```

## Structure

```
dotfiles/
├── .config/          # Application configurations
│   ├── hypr/         # Hyprland config
│   ├── waybar/       # Waybar config
│   ├── rofi/         # Rofi config
│   └── ...
├── packages/         # Package lists
│   ├── pacman-packages.txt
│   └── aur-packages.txt
├── system-info/      # Hardware & system details
├── scripts/          # Management scripts
│   ├── install.sh    # Full system setup
│   ├── post-install.sh # Post-install configuration
│   ├── backup.sh     # Backup configs
│   ├── update.sh     # Interactive update
│   ├── quick-update.sh # Non-interactive update
│   ├── system-info.sh # Capture system details
│   └── setup-daily-backup.sh # Auto-backup setup
├── .aliases          # Shell aliases
├── .env.template     # Environment variables template
└── README.md
```

## Scripts

### install.sh
- Installs all packages from package lists
- Creates symlinks for all configurations
- Sets up Hyprland environment
- Configures default shell

### backup.sh
- Copies current configurations to repository
- Updates package lists
- Preserves directory structure

### update.sh
- Runs backup.sh
- Updates package lists
- Interactive git commit and push

### quick-update.sh
- Non-interactive version of update.sh
- Usage: `./quick-update.sh "commit message"`

## First Time Setup

1. Fork/create your own repository on GitHub
2. Clone this repository
3. Run initial backup: `./scripts/backup.sh`
4. Set up git remote:
   ```bash
   cd ~/dotfiles
   git remote add origin https://github.com/YOUR_USERNAME/dotfiles.git
   git branch -M main
   git push -u origin main
   ```

## Adding New Configurations

1. Add the config directory/file to the `configs` array in `backup.sh`
2. Run `./scripts/backup.sh` to copy it
3. Commit and push changes

## Additional Features

### Aliases
Add to your shell config:
```bash
source ~/.aliases
```

Common aliases:
- `dot` - cd to dotfiles directory
- `dotup` - run interactive update
- `dotquick "message"` - quick commit and push
- `dotbackup` - backup current configs
- `hypreload` - reload Hyprland config

### Daily Automatic Backups
Set up automatic daily backups:
```bash
./scripts/setup-daily-backup.sh
```

### Environment Variables
1. Copy `.env.template` to `.env`
2. Fill in your API keys and secrets
3. Source in your shell: `source ~/dotfiles/.env`

### System Information
System details are captured in `system-info/` including:
- Hardware specifications
- Monitor configurations
- Audio devices
- Network interfaces
- Installed fonts

## Notes

- The install script creates symlinks, so changes to configs are automatically reflected in the repository
- Original files are backed up with `.bak` extension before creating symlinks
- Package lists are automatically generated from your current system
- Compatible with Asahi Linux (ARM64) - same configs will work
- `.env` files are gitignored for security
- Use machine-specific/ directory for configs that differ between machines
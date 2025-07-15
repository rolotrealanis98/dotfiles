# Arch Linux Dotfiles

Personal dotfiles for Arch Linux with Hyprland, Waybar, Rofi, and more.

## Quick Start

### On a new machine:
```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/install.sh
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
├── scripts/          # Management scripts
│   ├── install.sh    # Full system setup
│   ├── backup.sh     # Backup configs
│   ├── update.sh     # Interactive update
│   └── quick-update.sh # Non-interactive update
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

## Notes

- The install script creates symlinks, so changes to configs are automatically reflected in the repository
- Original files are backed up with `.bak` extension before creating symlinks
- Package lists are automatically generated from your current system
- Compatible with Asahi Linux (ARM64) - same configs will work
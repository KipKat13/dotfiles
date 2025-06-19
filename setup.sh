#!/bin/bash

# Arch Linux Hyprland Dotfiles Setup Script
# Author: KipKat13
# Description: Interactive setup script for fresh Arch installation with Hyprland

# Remove set -e to prevent immediate exit on errors
# set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Global variables
DOTFILES_REPO="https://github.com/KipKat13/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
LOG_FILE="$HOME/setup.log"

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
    log "INFO: $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
    log "WARNING: $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    log "ERROR: $1"
}

print_question() {
    echo -e "${CYAN}[QUESTION]${NC} $1"
}

# Ask yes/no question
ask_yes_no() {
    local question="$1"
    local default="$2"
    local answer
    
    if [[ "$default" == "y" ]]; then
        print_question "$question [Y/n]: "
    else
        print_question "$question [y/N]: "
    fi
    
    read -r answer
    
    if [[ -z "$answer" ]]; then
        answer="$default"
    fi
    
    [[ "$answer" =~ ^[Yy]$ ]]
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root!"
        exit 1
    fi
}

# Check if running on Arch Linux
check_arch() {
    if ! command -v pacman &> /dev/null; then
        print_error "This script is designed for Arch Linux!"
        exit 1
    fi
}

# Safe package installation with error handling
install_packages() {
    local package_type="$1"
    shift
    local packages=("$@")
    local failed_packages=()
    
    print_status "Installing $package_type packages..."
    
    for package in "${packages[@]}"; do
        print_status "Installing $package..."
        if [[ "$package_type" == "AUR" ]]; then
            if ! yay -S --needed --noconfirm "$package" 2>/dev/null; then
                print_warning "Failed to install AUR package: $package"
                failed_packages+=("$package")
            fi
        else
            if ! sudo pacman -S --needed --noconfirm "$package" 2>/dev/null; then
                print_warning "Failed to install package: $package"
                failed_packages+=("$package")
            fi
        fi
    done
    
    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        print_warning "The following $package_type packages failed to install:"
        printf '%s\n' "${failed_packages[@]}"
        echo
    fi
}

# Update system
update_system() {
    print_status "Updating system packages..."
    if ! sudo pacman -Syu --noconfirm; then
        print_error "Failed to update system packages"
        return 1
    fi
}

# Install AUR helper (yay)
install_aur_helper() {
    if command -v yay &> /dev/null; then
        print_status "AUR helper (yay) already installed"
        return 0
    fi
    
    print_status "Installing AUR helper (yay)..."
    
    # Install dependencies first
    install_packages "official" "base-devel" "git"
    
    cd /tmp || exit 1
    if ! git clone https://aur.archlinux.org/yay.git; then
        print_error "Failed to clone yay repository"
        return 1
    fi
    
    cd yay || exit 1
    if ! makepkg -si --noconfirm; then
        print_error "Failed to build yay"
        return 1
    fi
    
    cd ~ || exit 1
    rm -rf /tmp/yay
    
    print_status "AUR helper (yay) installed successfully"
}

# Install basic packages
install_basic_packages() {
    print_status "Installing basic packages..."
    
    local basic_packages=(
        # System essentials
        "base-devel"
        "git"
        "curl"
        "wget"
        "unzip"
        "zip"
        "htop"
        "neofetch"
        "tree"
        "man-db"
        "man-pages"
        
        # Network tools
        "networkmanager"
        "network-manager-applet"
        "wireless_tools"
        "wpa_supplicant"
        
        # Audio
        "pipewire"
        "pipewire-alsa"
        "pipewire-pulse"
        "pipewire-jack"
        "wireplumber"
        "pavucontrol"
        
        # Basic fonts
        "ttf-liberation"
        "ttf-dejavu"
        "noto-fonts"
        "noto-fonts-emoji"
    )
    
    install_packages "official" "${basic_packages[@]}"
}

# Install Hyprland and related packages
install_hyprland() {
    print_status "Installing Hyprland and related packages..."
    
    local hyprland_packages=(
        # Hyprland core
        "hyprland"
        "xdg-desktop-portal-hyprland"
        
        # Wayland essentials
        "wayland"
        "wayland-protocols"
        "wl-clipboard"
        
        # Display and graphics
        "qt5-wayland"
        "qt6-wayland"
        
        # Authentication
        "polkit"
        "polkit-gnome"
    )
    
    install_packages "official" "${hyprland_packages[@]}"
}

# Install additional Hyprland tools
install_hyprland_tools() {
    print_status "Installing additional Hyprland tools..."
    
    local tools=(
        # Status bar and notifications
        "waybar"
        "dunst"
        
        # Application launcher
        "wofi"
        
        # Screenshot and screen recording
        "grim"
        "slurp"
        "swappy"
        
        # File manager
        "thunar"
        "thunar-volman"
        
        # Image viewer
        "imv"
        
        # Terminal
        "kitty"
        "alacritty"
        
        # Archive tools
        "file-roller"
        "p7zip"
        "unrar"
    )
    
    install_packages "official" "${tools[@]}"
    
    # Try to install rofi-wayland from AUR if wofi isn't preferred
    if ask_yes_no "Install rofi-wayland (better launcher) from AUR?" "y"; then
        install_packages "AUR" "rofi-wayland"
    fi
}

# Install development tools
install_dev_tools() {
    if ask_yes_no "Install development tools?" "y"; then
        print_status "Installing development tools..."
        
        local dev_packages=(
            # Editors
            "neovim"
            "vim"
            
            # Programming languages
            "python"
            "python-pip"
            "nodejs"
            "npm"
            "rust"
            "go"
            
            # Version control
            "git"
            
            # Build tools
            "cmake"
            "make"
            "gcc"
            
            # Terminal tools
            "tmux"
            "zsh"
            "fish"
        )
        
        install_packages "official" "${dev_packages[@]}"
        
        # Install additional tools from AUR
        if ask_yes_no "Install additional development tools from AUR?" "y"; then
            local dev_aur_packages=(
                "visual-studio-code-bin"
                "github-cli"
                "starship"
            )
            install_packages "AUR" "${dev_aur_packages[@]}"
        fi
    fi
}

# Install media and graphics tools
install_media_tools() {
    if ask_yes_no "Install media and graphics tools?" "y"; then
        print_status "Installing media and graphics tools..."
        
        local media_packages=(
            # Media
            "vlc"
            "mpv"
            
            # Graphics (basic)
            "gimp"
            
            # Audio
            "audacity"
        )
        
        install_packages "official" "${media_packages[@]}"
        
        # Optional heavy graphics tools
        if ask_yes_no "Install heavy graphics tools (Inkscape, Blender)?" "n"; then
            local heavy_graphics=(
                "inkscape"
                "blender"
            )
            install_packages "official" "${heavy_graphics[@]}"
        fi
    fi
}

# Install gaming tools
install_gaming_tools() {
    if ask_yes_no "Install gaming tools?" "n"; then
        print_status "Installing gaming tools..."
        
        # Enable multilib repository first
        if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
            print_status "Enabling multilib repository..."
            sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
            sudo pacman -Sy
        fi
        
        local gaming_packages=(
            "steam"
            "lutris"
            "wine"
            "gamemode"
        )
        
        install_packages "official" "${gaming_packages[@]}"
    fi
}

# Install additional fonts
install_fonts() {
    if ask_yes_no "Install additional fonts?" "y"; then
        print_status "Installing additional fonts..."
        
        local font_packages=(
            "ttf-fira-code"
            "ttf-jetbrains-mono"
            "ttf-hack"
            "adobe-source-code-pro-fonts"
        )
        
        install_packages "official" "${font_packages[@]}"
        
        # Install Nerd Fonts from AUR
        if ask_yes_no "Install Nerd Fonts from AUR?" "y"; then
            local nerd_fonts=(
                "ttf-jetbrains-mono-nerd"
                "ttf-firacode-nerd"
            )
            install_packages "AUR" "${nerd_fonts[@]}"
        fi
    fi
}

# Detect monitors and generate monitor configuration
detect_and_configure_monitors() {
    print_status "Detecting monitors..."
    
    # Install wlr-randr for monitor detection if not already installed
    if ! command -v wlr-randr &> /dev/null; then
        install_packages "official" "wlr-randr"
    fi
    
    local monitor_config=""
    local temp_hypr_config="/tmp/hyprland_monitor_test.conf"
    
    # Create a minimal Hyprland config for monitor detection
    cat > "$temp_hypr_config" << 'EOF'
monitor=,preferred,auto,1
input {
    kb_layout = us
}
general {
    gaps_in = 0
    gaps_out = 0
    border_size = 1
}
EOF
    
    # Try to get monitor info using different methods
    local monitors_info=""
    
    # Method 1: Use hyprctl if Hyprland is running
    if pgrep -x "Hyprland" > /dev/null; then
        print_status "Hyprland is running, getting monitor info..."
        monitors_info=$(hyprctl monitors -j 2>/dev/null || echo "")
    fi
    
    # Method 2: Use drm info from /sys/class/drm
    if [[ -z "$monitors_info" ]]; then
        print_status "Reading monitor info from system..."
        for card in /sys/class/drm/card*/card*-*/status; do
            if [[ -f "$card" ]] && grep -q "connected" "$card"; then
                local connector=$(basename "$(dirname "$card")")
                local card_path=$(dirname "$(dirname "$card")")
                local edid_file="$card_path/$connector/edid"
                
                if [[ -f "$edid_file" ]] && [[ -s "$edid_file" ]]; then
                    # Try to get resolution from modes
                    local modes_file="$card_path/$connector/modes"
                    if [[ -f "$modes_file" ]]; then
                        local preferred_mode=$(head -1 "$modes_file")
                        if [[ -n "$preferred_mode" ]]; then
                            monitor_config+="monitor=$connector,$preferred_mode,auto,1"

# Setup shell
setup_shell() {
    # Create a flag file to track if shell setup is complete
    local shell_flag="$HOME/.shell_setup_complete"
    
    if [[ -f "$shell_flag" ]]; then
        print_status "Shell already set up (found flag file). Skipping..."
        return 0
    fi
    
    if ask_yes_no "Setup Zsh with Oh My Zsh?" "y"; then
        print_status "Setting up Zsh..."
        
        # Make sure zsh is installed
        if ! command -v zsh &> /dev/null; then
            install_packages "official" "zsh"
        fi
        
        # Install Oh My Zsh if not already installed
        if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
            print_status "Installing Oh My Zsh..."
            # Use RUNZSH=no to prevent Oh My Zsh from starting a new shell
            RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        fi
        
        # Change default shell (but don't switch immediately)
        if [[ "$SHELL" != "$(which zsh)" ]]; then
            print_status "Changing default shell to Zsh..."
            chsh -s "$(which zsh)"
            print_status "Default shell changed to Zsh (will take effect after reboot)"
        fi
        
        # Install popular Zsh plugins
        if ask_yes_no "Install popular Zsh plugins?" "y"; then
            local plugin_dir="${HOME}/.oh-my-zsh/custom/plugins"
            mkdir -p "$plugin_dir"
            
            if [[ ! -d "$plugin_dir/zsh-autosuggestions" ]]; then
                git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir/zsh-autosuggestions"
            fi
            
            if [[ ! -d "$plugin_dir/zsh-syntax-highlighting" ]]; then
                git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugin_dir/zsh-syntax-highlighting"
            fi
        fi
        
        # Create flag file to indicate shell setup is complete
        touch "$shell_flag"
        
        print_status "Shell setup completed!"
    fi
}

# Enable services
enable_services() {
    print_status "Enabling system services..."
    
    local services=(
        "NetworkManager"
    )
    
    # Only enable bluetooth if it's installed
    if systemctl list-unit-files | grep -q "bluetooth"; then
        services+=("bluetooth")
    fi
    
    for service in "${services[@]}"; do
        if systemctl list-unit-files | grep -q "$service"; then
            if sudo systemctl enable "$service" 2>/dev/null; then
                print_status "Enabled $service"
            else
                print_warning "Failed to enable $service"
            fi
        fi
    done
}

# Setup firewall
setup_firewall() {
    if ask_yes_no "Setup and enable firewall (ufw)?" "y"; then
        print_status "Setting up firewall..."
        install_packages "official" "ufw"
        if sudo ufw --force enable && sudo systemctl enable ufw; then
            print_status "Firewall enabled successfully"
        else
            print_warning "Failed to enable firewall"
        fi
    fi
}

# Main setup function
main() {
    clear
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════╗"
    echo "║     Arch Linux Hyprland Setup        ║"
    echo "║           by KipKat13                 ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
    echo
    
    print_status "Starting Arch Linux Hyprland setup..."
    print_status "Logs will be saved to: $LOG_FILE"
    echo
    
    # Pre-flight checks
    check_root
    check_arch
    
    # Ask user what they want to install
    echo -e "${BLUE}=== Installation Options ===${NC}"
    echo "This script will guide you through setting up your Arch system."
    echo "You'll be asked about each component before installation."
    echo
    
    if ask_yes_no "Continue with the setup?" "y"; then
        # Core installation steps (with error handling)
        print_status "=== Core System Setup ==="
        update_system || print_warning "System update had issues, continuing..."
        install_aur_helper || { print_error "Failed to install AUR helper, exiting"; exit 1; }
        install_basic_packages
        install_hyprland
        install_hyprland_tools
        
        # Optional components
        print_status "=== Optional Components ==="
        install_dev_tools
        install_media_tools
        install_gaming_tools
        install_fonts
        
        # Configuration
        print_status "=== Configuration ==="
        setup_dotfiles
        setup_shell
        enable_services
        setup_firewall
        
        echo
        print_status "Setup completed!"
        echo -e "${GREEN}"
        echo "╔═══════════════════════════════════════╗"
        echo "║            Setup Complete!           ║"
        echo "╚═══════════════════════════════════════╝"
        echo -e "${NC}"
        echo
        print_status "Next steps:"
        print_status "1. Reboot your system: sudo reboot"
        print_status "2. After reboot, start Hyprland: Hyprland"
        print_status "3. If you changed shell to Zsh, log out and back in"
        echo
        print_status "Check the setup log for any warnings: $LOG_FILE"
        
        if ask_yes_no "Reboot now?" "n"; then
            sudo reboot
        fi
    else
        print_status "Setup cancelled by user."
        exit 0
    fi
}

# Trap to handle interruption
trap 'print_error "Setup interrupted by user"; exit 1' INT

# Run main function
main "$@"\n'
                            print_status "Found monitor: $connector with resolution $preferred_mode"
                        fi
                    fi
                fi
            fi
        done
    fi
    
    # Method 3: Use xrandr if available (fallback)
    if [[ -z "$monitor_config" ]] && command -v xrandr &> /dev/null; then
        print_status "Using xrandr for monitor detection..."
        while IFS= read -r line; do
            if [[ "$line" =~ ^([A-Za-z0-9-]+)\ connected.* ]]; then
                local monitor_name="${BASH_REMATCH[1]}"
                # Get preferred resolution
                local resolution=$(echo "$line" | grep -o '[0-9]\+x[0-9]\+' | head -1)
                if [[ -n "$resolution" ]]; then
                    monitor_config+="monitor=$monitor_name,$resolution,auto,1"

# Setup shell
setup_shell() {
    if ask_yes_no "Setup Zsh with Oh My Zsh?" "y"; then
        print_status "Setting up Zsh..."
        
        # Make sure zsh is installed
        if ! command -v zsh &> /dev/null; then
            install_packages "official" "zsh"
        fi
        
        # Install Oh My Zsh if not already installed
        if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
            print_status "Installing Oh My Zsh..."
            RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        fi
        
        # Change default shell
        if [[ "$SHELL" != "$(which zsh)" ]]; then
            print_status "Changing default shell to Zsh..."
            chsh -s "$(which zsh)"
        fi
        
        # Install popular Zsh plugins
        if ask_yes_no "Install popular Zsh plugins?" "y"; then
            local plugin_dir="${HOME}/.oh-my-zsh/custom/plugins"
            
            if [[ ! -d "$plugin_dir/zsh-autosuggestions" ]]; then
                git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir/zsh-autosuggestions"
            fi
            
            if [[ ! -d "$plugin_dir/zsh-syntax-highlighting" ]]; then
                git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugin_dir/zsh-syntax-highlighting"
            fi
        fi
    fi
}

# Enable services
enable_services() {
    print_status "Enabling system services..."
    
    local services=(
        "NetworkManager"
    )
    
    # Only enable bluetooth if it's installed
    if systemctl list-unit-files | grep -q "bluetooth"; then
        services+=("bluetooth")
    fi
    
    for service in "${services[@]}"; do
        if systemctl list-unit-files | grep -q "$service"; then
            if sudo systemctl enable "$service" 2>/dev/null; then
                print_status "Enabled $service"
            else
                print_warning "Failed to enable $service"
            fi
        fi
    done
}

# Setup firewall
setup_firewall() {
    if ask_yes_no "Setup and enable firewall (ufw)?" "y"; then
        print_status "Setting up firewall..."
        install_packages "official" "ufw"
        if sudo ufw --force enable && sudo systemctl enable ufw; then
            print_status "Firewall enabled successfully"
        else
            print_warning "Failed to enable firewall"
        fi
    fi
}

# Main setup function
main() {
    clear
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════╗"
    echo "║     Arch Linux Hyprland Setup        ║"
    echo "║           by KipKat13                 ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
    echo
    
    print_status "Starting Arch Linux Hyprland setup..."
    print_status "Logs will be saved to: $LOG_FILE"
    echo
    
    # Pre-flight checks
    check_root
    check_arch
    
    # Ask user what they want to install
    echo -e "${BLUE}=== Installation Options ===${NC}"
    echo "This script will guide you through setting up your Arch system."
    echo "You'll be asked about each component before installation."
    echo
    
    if ask_yes_no "Continue with the setup?" "y"; then
        # Core installation steps (with error handling)
        print_status "=== Core System Setup ==="
        update_system || print_warning "System update had issues, continuing..."
        install_aur_helper || { print_error "Failed to install AUR helper, exiting"; exit 1; }
        install_basic_packages
        install_hyprland
        install_hyprland_tools
        
        # Optional components
        print_status "=== Optional Components ==="
        install_dev_tools
        install_media_tools
        install_gaming_tools
        install_fonts
        
        # Configuration
        print_status "=== Configuration ==="
        setup_dotfiles
        setup_shell
        enable_services
        setup_firewall
        
        echo
        print_status "Setup completed!"
        echo -e "${GREEN}"
        echo "╔═══════════════════════════════════════╗"
        echo "║            Setup Complete!           ║"
        echo "╚═══════════════════════════════════════╝"
        echo -e "${NC}"
        echo
        print_status "Next steps:"
        print_status "1. Reboot your system: sudo reboot"
        print_status "2. After reboot, start Hyprland: Hyprland"
        print_status "3. If you changed shell to Zsh, log out and back in"
        echo
        print_status "Check the setup log for any warnings: $LOG_FILE"
        
        if ask_yes_no "Reboot now?" "n"; then
            sudo reboot
        fi
    else
        print_status "Setup cancelled by user."
        exit 0
    fi
}

# Trap to handle interruption
trap 'print_error "Setup interrupted by user"; exit 1' INT

# Run main function
main "$@"\n'
                    print_status "Found monitor: $monitor_name with resolution $resolution"
                fi
            fi
        done <<< "$(xrandr 2>/dev/null)"
    fi
    
    # Fallback: Use generic configuration
    if [[ -z "$monitor_config" ]]; then
        print_warning "Could not detect specific monitors, using auto-configuration"
        monitor_config="monitor=,preferred,auto,1"
    fi
    
    # Save the monitor configuration
    echo "$monitor_config" > /tmp/detected_monitors.conf
    print_status "Monitor configuration saved to /tmp/detected_monitors.conf"
    
    # Clean up
    rm -f "$temp_hypr_config"
    
    echo "$monitor_config"
}

# Update Hyprland monitor configuration
update_hyprland_monitor_config() {
    local hypr_config_path="$1"
    local monitor_config="$2"
    
    if [[ ! -f "$hypr_config_path" ]]; then
        print_warning "Hyprland config file not found: $hypr_config_path"
        return 1
    fi
    
    print_status "Updating Hyprland monitor configuration..."
    
    # Create backup
    cp "$hypr_config_path" "$hypr_config_path.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Remove existing monitor lines and add new ones
    # Create temp file with new config
    local temp_config="/tmp/hyprland_config_temp"
    
    # Remove existing monitor configurations
    grep -v '^monitor=' "$hypr_config_path" > "$temp_config"
    
    # Add new monitor configuration at the top
    {
        echo "# Auto-detected monitor configuration"
        echo "$monitor_config"
        echo ""
        cat "$temp_config"
    } > "$hypr_config_path"
    
    rm -f "$temp_config"
    
    print_status "Monitor configuration updated in $hypr_config_path"
}

# Comprehensive dotfiles setup function
setup_dotfiles() {
    # Create a flag file to track if dotfiles setup is complete
    local dotfiles_flag="$HOME/.dotfiles_setup_complete"
    
    if [[ -f "$dotfiles_flag" ]]; then
        print_status "Dotfiles already set up (found flag file). Skipping..."
        return 0
    fi
    
    if ask_yes_no "Clone and setup dotfiles from your repository?" "y"; then
        print_status "Setting up dotfiles..."
        
        # Backup existing configs
        local backup_dir="$HOME/.config.backup.$(date +%Y%m%d_%H%M%S)"
        if [[ -d "$HOME/.config" ]]; then
            print_status "Backing up existing .config directory to $backup_dir..."
            mv "$HOME/.config" "$backup_dir"
        fi
        
        # Clone dotfiles repository
        if [[ -d "$DOTFILES_DIR" ]]; then
            print_status "Dotfiles directory already exists, pulling latest changes..."
            cd "$DOTFILES_DIR" || exit 1
            git pull
        else
            print_status "Cloning dotfiles repository..."
            if ! git clone "$DOTFILES_REPO" "$DOTFILES_DIR"; then
                print_error "Failed to clone dotfiles repository"
                return 1
            fi
        fi
        
        cd "$DOTFILES_DIR" || exit 1
        
        print_status "Setting up dotfiles..."
        
        # Create .config directory if it doesn't exist
        mkdir -p "$HOME/.config"
        
        # Function to safely create symlinks
        create_symlink() {
            local source="$1"
            local target="$2"
            
            if [[ -e "$source" ]]; then
                # Remove existing file/directory if it exists
                if [[ -e "$target" ]] || [[ -L "$target" ]]; then
                    rm -rf "$target"
                fi
                
                # Create directory for target if needed
                mkdir -p "$(dirname "$target")"
                
                # Create symlink
                ln -sf "$source" "$target"
                print_status "Created symlink: $target -> $source"
            else
                print_warning "Source file/directory not found: $source"
            fi
        }
        
        # Auto-detect and setup common dotfiles structure
        print_status "Auto-detecting dotfiles structure..."
        
        # Check for common directory structures and create symlinks
        
        # Method 1: Check if there's a .config directory in dotfiles
        if [[ -d "$DOTFILES_DIR/.config" ]]; then
            print_status "Found .config directory in dotfiles"
            for config_dir in "$DOTFILES_DIR/.config"/*; do
                if [[ -d "$config_dir" ]]; then
                    dir_name=$(basename "$config_dir")
                    create_symlink "$config_dir" "$HOME/.config/$dir_name"
                fi
            done
        fi
        
        # Method 2: Check for individual config directories in root
        local common_configs=("hypr" "waybar" "kitty" "alacritty" "rofi" "wofi" "dunst" "nvim" "vim")
        for config in "${common_configs[@]}"; do
            if [[ -d "$DOTFILES_DIR/$config" ]]; then
                create_symlink "$DOTFILES_DIR/$config" "$HOME/.config/$config"
            fi
        done
        
        # Method 3: Check for home directory dotfiles
        local home_dotfiles=(".zshrc" ".bashrc" ".vimrc" ".tmux.conf" ".gitconfig")
        for dotfile in "${home_dotfiles[@]}"; do
            if [[ -f "$DOTFILES_DIR/$dotfile" ]]; then
                create_symlink "$DOTFILES_DIR/$dotfile" "$HOME/$dotfile"
            fi
        done
        
        # Method 4: Check for install script in dotfiles (but don't run if it might restart the setup)
        if [[ -f "$DOTFILES_DIR/install.sh" ]]; then
            print_status "Found install script in dotfiles repository"
            if ask_yes_no "Run the dotfiles install script? (WARNING: Make sure it doesn't restart this setup)" "n"; then
                cd "$DOTFILES_DIR" || exit 1
                chmod +x install.sh
                # Run in subshell to prevent it from affecting our script
                (./install.sh)
            fi
        elif [[ -f "$DOTFILES_DIR/setup.sh" ]]; then
            print_status "Found setup script in dotfiles repository"
            if ask_yes_no "Run the dotfiles setup script? (WARNING: Make sure it doesn't restart this setup)" "n"; then
                cd "$DOTFILES_DIR" || exit 1
                chmod +x setup.sh
                # Run in subshell to prevent it from affecting our script
                (./setup.sh)
            fi
        fi
        
        # Configure monitors for Hyprland
        local hypr_config_path=""
        if [[ -f "$HOME/.config/hypr/hyprland.conf" ]]; then
            hypr_config_path="$HOME/.config/hypr/hyprland.conf"
        elif [[ -f "$HOME/.config/hypr/hypr.conf" ]]; then
            hypr_config_path="$HOME/.config/hypr/hypr.conf"
        fi
        
        if [[ -n "$hypr_config_path" ]]; then
            if ask_yes_no "Auto-detect and configure monitors for Hyprland?" "y"; then
                local monitor_config
                monitor_config=$(detect_and_configure_monitors)
                update_hyprland_monitor_config "$hypr_config_path" "$monitor_config"
            fi
        else
            print_warning "Hyprland configuration file not found. Skipping monitor configuration."
        fi
        
        print_status "Dotfiles setup completed!"
        
        # Create flag file to indicate dotfiles setup is complete
        touch "$dotfiles_flag"
        
        # List what was set up
        print_status "The following symlinks were created:"
        find "$HOME" -maxdepth 2 -type l -ls 2>/dev/null | grep "$DOTFILES_DIR" || print_warning "No symlinks found or ls command failed"
        
        # Return to home directory
        cd "$HOME" || exit 1
    fi
}

# Setup shell
setup_shell() {
    if ask_yes_no "Setup Zsh with Oh My Zsh?" "y"; then
        print_status "Setting up Zsh..."
        
        # Make sure zsh is installed
        if ! command -v zsh &> /dev/null; then
            install_packages "official" "zsh"
        fi
        
        # Install Oh My Zsh if not already installed
        if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
            print_status "Installing Oh My Zsh..."
            RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        fi
        
        # Change default shell
        if [[ "$SHELL" != "$(which zsh)" ]]; then
            print_status "Changing default shell to Zsh..."
            chsh -s "$(which zsh)"
        fi
        
        # Install popular Zsh plugins
        if ask_yes_no "Install popular Zsh plugins?" "y"; then
            local plugin_dir="${HOME}/.oh-my-zsh/custom/plugins"
            
            if [[ ! -d "$plugin_dir/zsh-autosuggestions" ]]; then
                git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir/zsh-autosuggestions"
            fi
            
            if [[ ! -d "$plugin_dir/zsh-syntax-highlighting" ]]; then
                git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugin_dir/zsh-syntax-highlighting"
            fi
        fi
    fi
}

# Enable services
enable_services() {
    print_status "Enabling system services..."
    
    local services=(
        "NetworkManager"
    )
    
    # Only enable bluetooth if it's installed
    if systemctl list-unit-files | grep -q "bluetooth"; then
        services+=("bluetooth")
    fi
    
    for service in "${services[@]}"; do
        if systemctl list-unit-files | grep -q "$service"; then
            if sudo systemctl enable "$service" 2>/dev/null; then
                print_status "Enabled $service"
            else
                print_warning "Failed to enable $service"
            fi
        fi
    done
}

# Setup firewall
setup_firewall() {
    if ask_yes_no "Setup and enable firewall (ufw)?" "y"; then
        print_status "Setting up firewall..."
        install_packages "official" "ufw"
        if sudo ufw --force enable && sudo systemctl enable ufw; then
            print_status "Firewall enabled successfully"
        else
            print_warning "Failed to enable firewall"
        fi
    fi
}

# Main setup function
main() {
    clear
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════╗"
    echo "║     Arch Linux Hyprland Setup        ║"
    echo "║           by KipKat13                 ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
    echo
    
    print_status "Starting Arch Linux Hyprland setup..."
    print_status "Logs will be saved to: $LOG_FILE"
    echo
    
    # Pre-flight checks
    check_root
    check_arch
    
    # Ask user what they want to install
    echo -e "${BLUE}=== Installation Options ===${NC}"
    echo "This script will guide you through setting up your Arch system."
    echo "You'll be asked about each component before installation."
    echo
    
    if ask_yes_no "Continue with the setup?" "y"; then
        # Core installation steps (with error handling)
        print_status "=== Core System Setup ==="
        update_system || print_warning "System update had issues, continuing..."
        install_aur_helper || { print_error "Failed to install AUR helper, exiting"; exit 1; }
        install_basic_packages
        install_hyprland
        install_hyprland_tools
        
        # Optional components
        print_status "=== Optional Components ==="
        install_dev_tools
        install_media_tools
        install_gaming_tools
        install_fonts
        
        # Configuration
        print_status "=== Configuration ==="
        setup_dotfiles
        setup_shell
        enable_services
        setup_firewall
        
        echo
        print_status "Setup completed!"
        echo -e "${GREEN}"
        echo "╔═══════════════════════════════════════╗"
        echo "║            Setup Complete!           ║"
        echo "╚═══════════════════════════════════════╝"
        echo -e "${NC}"
        echo
        print_status "Next steps:"
        print_status "1. Reboot your system: sudo reboot"
        print_status "2. After reboot, start Hyprland: Hyprland"
        print_status "3. If you changed shell to Zsh, log out and back in"
        echo
        print_status "Check the setup log for any warnings: $LOG_FILE"
        
        if ask_yes_no "Reboot now?" "n"; then
            sudo reboot
        fi
    else
        print_status "Setup cancelled by user."
        exit 0
    fi
}

# Trap to handle interruption
trap 'print_error "Setup interrupted by user"; exit 1' INT

# Run main function
main "$@"

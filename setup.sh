#!/bin/bash

# Arch Linux Hyprland Dotfiles Setup Script
# Author: KipKat13
# Description: Interactive setup script for fresh Arch installation with Hyprland

set -e

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

# Update system
update_system() {
    print_status "Updating system packages..."
    sudo pacman -Syu --noconfirm
}

# Install AUR helper (yay)
install_aur_helper() {
    if command -v yay &> /dev/null; then
        print_status "AUR helper (yay) already installed"
        return
    fi
    
    print_status "Installing AUR helper (yay)..."
    sudo pacman -S --needed --noconfirm base-devel git
    
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
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
        
        # Fonts
        "ttf-liberation"
        "ttf-dejavu"
        "ttf-opensans"
        "noto-fonts"
        "noto-fonts-emoji"
    )
    
    sudo pacman -S --needed --noconfirm "${basic_packages[@]}"
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
        "wayland-utils"
        "wl-clipboard"
        "wlroots"
        
        # Display and graphics
        "qt5-wayland"
        "qt6-wayland"
        "glfw-wayland"
        
        # Authentication
        "polkit"
        "polkit-gnome"
    )
    
    sudo pacman -S --needed --noconfirm "${hyprland_packages[@]}"
}

# Install additional Hyprland tools
install_hyprland_tools() {
    print_status "Installing additional Hyprland tools..."
    
    local tools=(
        # Status bar and notifications
        "waybar"
        "dunst"
        
        # Application launcher
        "rofi-wayland"
        
        # Screenshot and screen recording
        "grim"
        "slurp"
        "swappy"
        "wf-recorder"
        
        # File manager
        "thunar"
        "thunar-volman"
        "thunar-archive-plugin"
        
        # Image viewer
        "imv"
        
        # Media player
        "mpv"
        
        # PDF viewer
        "zathura"
        "zathura-pdf-mupdf"
        
        # Archive tools
        "file-roller"
        "p7zip"
        "unrar"
    )
    
    sudo pacman -S --needed --noconfirm "${tools[@]}"
}

# Install development tools
install_dev_tools() {
    if ask_yes_no "Install development tools?" "y"; then
        print_status "Installing development tools..."
        
        local dev_packages=(
            # Editors
            "neovim"
            "code"
            
            # Programming languages
            "python"
            "python-pip"
            "nodejs"
            "npm"
            "rust"
            "go"
            
            # Version control
            "git"
            "github-cli"
            
            # Build tools
            "cmake"
            "make"
            "gcc"
            "clang"
            
            # Debugging
            "gdb"
            "valgrind"
            
            # Terminal tools
            "tmux"
            "zsh"
            "fish"
            "starship"
        )
        
        sudo pacman -S --needed --noconfirm "${dev_packages[@]}"
        
        # Install additional AUR packages for development
        if ask_yes_no "Install additional development tools from AUR?" "y"; then
            yay -S --needed --noconfirm \
                visual-studio-code-bin \
                postman-bin \
                discord \
                slack-desktop
        fi
    fi
}

# Install media and graphics tools
install_media_tools() {
    if ask_yes_no "Install media and graphics tools?" "y"; then
        print_status "Installing media and graphics tools..."
        
        local media_packages=(
            # Graphics
            "gimp"
            "inkscape"
            "blender"
            
            # Media
            "vlc"
            "obs-studio"
            "audacity"
            
            # Photography
            "rawtherapee"
            "darktable"
        )
        
        sudo pacman -S --needed --noconfirm "${media_packages[@]}"
    fi
}

# Install gaming tools
install_gaming_tools() {
    if ask_yes_no "Install gaming tools?" "n"; then
        print_status "Installing gaming tools..."
        
        local gaming_packages=(
            "steam"
            "lutris"
            "wine"
            "winetricks"
            "gamemode"
            "mangohud"
        )
        
        sudo pacman -S --needed --noconfirm "${gaming_packages[@]}"
        
        # Enable multilib repository for 32-bit support
        if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
            print_status "Enabling multilib repository..."
            sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
            sudo pacman -Sy
        fi
    fi
}

# Install additional fonts
install_fonts() {
    if ask_yes_no "Install additional fonts (including Nerd Fonts)?" "y"; then
        print_status "Installing additional fonts..."
        
        local font_packages=(
            "ttf-fira-code"
            "ttf-jetbrains-mono"
            "ttf-hack"
            "ttf-ubuntu-font-family"
            "adobe-source-code-pro-fonts"
        )
        
        sudo pacman -S --needed --noconfirm "${font_packages[@]}"
        
        # Install Nerd Fonts from AUR
        yay -S --needed --noconfirm \
            ttf-jetbrains-mono-nerd \
            ttf-firacode-nerd \
            ttf-hack-nerd
    fi
}

# Setup dotfiles
setup_dotfiles() {
    if ask_yes_no "Clone and setup dotfiles?" "y"; then
        print_status "Setting up dotfiles..."
        
        # Backup existing configs
        if [[ -d "$HOME/.config" ]]; then
            print_status "Backing up existing .config directory..."
            mv "$HOME/.config" "$HOME/.config.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        
        # Clone dotfiles repository
        if [[ -d "$DOTFILES_DIR" ]]; then
            print_status "Dotfiles directory already exists, pulling latest changes..."
            cd "$DOTFILES_DIR"
            git pull
        else
            print_status "Cloning dotfiles repository..."
            git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
        fi
        
        cd "$DOTFILES_DIR"
        
        # Create symbolic links (customize this based on your repo structure)
        print_status "Creating symbolic links..."
        
        # Example symlinks - adjust based on your actual dotfiles structure
        ln -sf "$DOTFILES_DIR/.config" "$HOME/.config"
        
        # If you have specific files in your repo, symlink them here
        # ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
        # ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
        # ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
        
        print_status "Dotfiles setup complete!"
    fi
}

# Setup shell
setup_shell() {
    if ask_yes_no "Setup Zsh as default shell?" "y"; then
        print_status "Setting up Zsh..."
        
        # Install Oh My Zsh
        if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
            print_status "Installing Oh My Zsh..."
            sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        fi
        
        # Change default shell
        if [[ "$SHELL" != "$(which zsh)" ]]; then
            print_status "Changing default shell to Zsh..."
            chsh -s "$(which zsh)"
        fi
        
        # Install popular Zsh plugins
        if ask_yes_no "Install popular Zsh plugins (zsh-autosuggestions, zsh-syntax-highlighting)?" "y"; then
            git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" 2>/dev/null || true
            git clone https://github.com/zsh-users/zsh-syntax-highlighting "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" 2>/dev/null || true
        fi
    fi
}

# Enable services
enable_services() {
    print_status "Enabling system services..."
    
    local services=(
        "NetworkManager"
        "bluetooth"
    )
    
    for service in "${services[@]}"; do
        if systemctl list-unit-files | grep -q "$service"; then
            sudo systemctl enable "$service"
            print_status "Enabled $service"
        fi
    done
}

# Setup firewall
setup_firewall() {
    if ask_yes_no "Setup and enable firewall (ufw)?" "y"; then
        print_status "Setting up firewall..."
        sudo pacman -S --needed --noconfirm ufw
        sudo ufw enable
        sudo systemctl enable ufw
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
        # Core installation steps
        update_system
        install_aur_helper
        install_basic_packages
        install_hyprland
        install_hyprland_tools
        
        # Optional components
        install_dev_tools
        install_media_tools
        install_gaming_tools
        install_fonts
        
        # Configuration
        setup_dotfiles
        setup_shell
        enable_services
        setup_firewall
        
        echo
        print_status "Setup completed successfully!"
        echo -e "${GREEN}"
        echo "╔═══════════════════════════════════════╗"
        echo "║            Setup Complete!           ║"
        echo "╚═══════════════════════════════════════╝"
        echo -e "${NC}"
        echo
        print_status "Please reboot your system to ensure all changes take effect."
        print_status "After reboot, you can start Hyprland by typing 'Hyprland' in your terminal."
        echo
        print_warning "If you changed your shell to Zsh, you may need to log out and back in."
        
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

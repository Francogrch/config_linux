#!/bin/bash

# --- DYNAMIC CONFIGURATION ---
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURRENT_ACTUAL_USER=$(logname || echo $USER)
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Global variables
MANUAL_MODE=false
INSTALL_PICOM=true

ask_user() {
  if [ "$MANUAL_MODE" = false ]; then return 0; fi
  echo -e "\n${BLUE}:: $1 [y/n]${NC}"
  read -r response
  [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
}

# --- FUNCTIONS ---

install_core() {
  echo -e "${GREEN}Configuring base environment and Zsh dependencies...${NC}"
  sudo sed -i 's/main$/main contrib non-free non-free-firmware/' /etc/apt/sources.list
  sudo apt update

  # Added libfuse2 for Neovim and rsync for config migration
  PACKAGES="bspwm sxhkd lightdm lightdm-gtk-greeter alacritty polybar feh nitrogen lxappearance \
              firefox-esr i3lock-fancy xinit x11-xserver-utils zsh thunar kitty flameshot blueman \
              x11-utils rofi unzip fzf bat fd-find lsd zoxide tree zsh-autosuggestions \
              zsh-syntax-highlighting libfuse2 rsync nodejs npm python3-venv python3-pip vim vlc chromium libreoffice obs-studio"

  [ "$INSTALL_PICOM" = true ] && PACKAGES="$PACKAGES picom"
  sudo apt install -y $PACKAGES

  # Symlinks for fd and bat (Debian compatibility)
  mkdir -p "$HOME/.local/bin"
  ln -sf $(which fdfind) "$HOME/.local/bin/fd"
  ln -sf $(which batcat) "$HOME/.local/bin/bat"

  # Fonts
  mkdir -p ~/.local/share/fonts
  URL_FONT="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.zip"
  wget -q --show-progress "$URL_FONT" -O /tmp/Iosevka.zip
  unzip -qo /tmp/Iosevka.zip -d ~/.local/share/fonts/
  fc-cache -fv

  # Oh My Zsh
  export ZSH="$HOME/.oh-my-zsh"
  [ -d "$ZSH" ] && rm -rf "$ZSH"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  # Zsh Plugins/Themes
  echo -e "${BLUE}Installing Zsh Plugins and Themes...${NC}"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  # Fix for your .zshrc: Ensure /usr/share/zsh-autocomplete exists
  sudo rm -rf /usr/share/zsh-autocomplete
  sudo git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git /usr/share/zsh-autocomplete

  # Restore configs
  echo -e "${BLUE}Restoring .config files...${NC}"
  mkdir -p ~/.config
  if [ "$INSTALL_PICOM" = true ]; then
    cp -r "$BASE_DIR/.config"/* ~/.config/
  else
    rsync -av --exclude='picom' "$BASE_DIR/.config/" ~/.config/
  fi

  [ -d "$BASE_DIR/images" ] && cp -r "$BASE_DIR/images"/* ~/images/
  [ -f "$BASE_DIR/.zshrc" ] && cp "$BASE_DIR/.zshrc" "$HOME/.zshrc"

  sudo chsh -s $(which zsh) $CURRENT_ACTUAL_USER
}

install_dev_apps() {
  echo -e "${GREEN}Installing Dev Apps (VS Code, DBeaver, Neovim)...${NC}"

  # Repositories
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/vscode.gpg >/dev/null
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
  wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/dbeaver.gpg
  echo "deb [signed-by=/etc/apt/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
  sudo apt update && sudo apt install -y code dbeaver-ce flatpak

  # --- REFINED NEOVIM INSTALLATION ---
  echo -e "${BLUE}Downloading Neovim...${NC}"
  sudo rm -f /usr/local/bin/nvim
  # Download directly to /usr/local/bin to avoid move errors
  sudo curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage -o /usr/local/bin/nvim
  sudo chmod +x /usr/local/bin/nvim

  # Flatpak apps (Postman, Vesktop)
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install flathub dev.vencord.Vesktop com.getpostman.Postman -y
}

# --- OTHER FUNCTIONS REMAIN UNCHANGED ---
install_docker() {
  sudo apt install -y ca-certificates gnupg lsb-release
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker $CURRENT_ACTUAL_USER
}

install_node() {
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env)"
  fnm install --latest
  npm install -g pnpm
}

install_postgres() {
  sudo apt install -y postgresql postgresql-contrib
  read -p "Enter username for Postgres (Default: $CURRENT_ACTUAL_USER): " PG_USER
  PG_USER=${PG_USER:-$CURRENT_ACTUAL_USER}
  read -sp "Set password for Postgres user '$PG_USER': " PG_PASS
  echo ""
  sudo -u postgres psql -c "CREATE USER $PG_USER WITH PASSWORD '$PG_PASS' SUPERUSER;"
  sudo -u postgres psql -c "CREATE DATABASE $PG_USER OWNER $PG_USER;"
}

install_nvidia() {
  sudo apt install -y linux-headers-$(uname -r) nvidia-driver firmware-misc-nonfree nvidia-settings nvidia-xconfig
  echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf
  sudo nvidia-xconfig
}

install_audio() {
  sudo apt install -y pipewire-audio-client-libraries pipewire-pulse pipewire-alsa pipewire-jack wireplumber pavucontrol
  systemctl --user --now enable pipewire.service pipewire-pulse.service wireplumber.service
}

# --- MAIN MENU ---
clear
echo -e "${GREEN}DEBIAN PROFESSIONAL DEPLOYMENT SYSTEM${NC}"
echo "1) Full Install (Desktop - NVIDIA/Picom)"
echo "2) Laptop Install (No NVIDIA/Picom)"
echo "3) Manual Selection"
read -p "Selection [1-3]: " mode

case $mode in
1)
  MANUAL_MODE=false
  INSTALL_PICOM=true
  install_core && install_nvidia && install_audio && install_postgres && install_node && install_docker && install_dev_apps
  ;;
2)
  MANUAL_MODE=false
  INSTALL_PICOM=false
  install_core && install_audio && install_postgres && install_node && install_docker && install_dev_apps
  ;;
3)
  MANUAL_MODE=true
  ask_user "Core?" && install_core
  ask_user "NVIDIA?" && install_nvidia
  ask_user "Audio?" && install_audio
  ask_user "Postgres?" && install_postgres
  ask_user "Node?" && install_node
  ask_user "Docker?" && install_docker
  ask_user "Apps?" && install_dev_apps
  ;;
esac

echo -e "\n${GREEN}Deployment finished! Reboot recommended.${NC}"

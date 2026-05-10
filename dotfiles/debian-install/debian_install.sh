#!/bin/bash

# --- DYNAMIC CONFIGURATION ---
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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

  # Core packages + Zsh Dependencies (fzf, bat, fd, lsd, zoxide, tree)
  PACKAGES="bspwm sxhkd lightdm lightdm-gtk-greeter alacritty polybar feh nitrogen lxappearance \
              firefox-esr i3lock-fancy xinit x11-xserver-utils zsh thunar kitty flameshot blueman \
              x11-utils rofi unzip fzf bat fd-find lsd zoxide tree zsh-autosuggestions zsh-syntax-highlighting"

  [ "$INSTALL_PICOM" = true ] && PACKAGES="$PACKAGES picom"
  sudo apt install -y $PACKAGES

  # Fix for fd and bat naming in Debian (aliasing to match your .zshrc)
  mkdir -p ~/.local/bin
  ln -sf $(which fdfind) ~/.local/bin/fd
  ln -sf $(which batcat) ~/.local/bin/bat

  # Fonts & Configs
  mkdir -p ~/.config ~/.local/share/fonts ~/images
  URL_FONT="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.zip"
  wget -q --show-progress "$URL_FONT" -O /tmp/Iosevka.zip
  unzip -q /tmp/Iosevka.zip -d ~/.local/share/fonts/
  rm /tmp/Iosevka.zip && fc-cache -fv

  # Oh My Zsh + Powerlevel10k
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  # Zsh Autocomplete (required by your .zshrc)
  git clone https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete

  # Restoration
  [ -d "$BASE_DIR/.config" ] && ([ "$INSTALL_PICOM" = true ] && cp -r "$BASE_DIR/.config"/* ~/.config/ || rsync -av --exclude='picom' "$BASE_DIR/.config/" ~/.config/)
  [ -d "$BASE_DIR/images" ] && cp -r "$BASE_DIR/images"/* ~/images/
  [ -f "$BASE_DIR/.zshrc" ] && cp "$BASE_DIR/.zshrc" "$HOME/.zshrc"

  sudo chsh -s $(which zsh) $USER
}

install_docker() {
  echo -e "${GREEN}Installing Docker and Docker Compose...${NC}"
  sudo apt install -y ca-certificates gnupg
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker $USER
}

install_node() {
  echo -e "${GREEN}Installing Node.js (via Fast Node Manager), NPM, and PNPM...${NC}"
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env)"
  fnm install --latest
  npm install -g pnpm
}

install_postgres() {
  echo -e "${GREEN}Installing PostgreSQL...${NC}"
  sudo apt install -y postgresql postgresql-contrib
  echo -e "${BLUE}Configuring PostgreSQL user 'franco'...${NC}"
  read -sp "Set password for postgres user 'franco': " PG_PASS
  sudo -u postgres psql -c "CREATE USER franco WITH PASSWORD '$PG_PASS' SUPERUSER;"
  sudo -u postgres psql -c "CREATE DATABASE franco OWNER franco;"
}

install_nvidia() {
  echo -e "${GREEN}Installing NVIDIA drivers...${NC}"
  sudo apt install -y linux-headers-$(uname -r) nvidia-driver firmware-misc-nonfree nvidia-settings nvidia-xconfig
  echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf
  sudo nvidia-xconfig
}

install_audio() {
  echo -e "${GREEN}Configuring Pipewire...${NC}"
  sudo apt install -y pipewire-audio-client-libraries pipewire-pulse pipewire-alsa pipewire-jack wireplumber pavucontrol
  systemctl --user --now enable pipewire.service pipewire-pulse.service wireplumber.service
}

install_dev_apps() {
  echo -e "${GREEN}Installing VS Code, DBeaver, Neovim, Vesktop...${NC}"
  # VS Code & DBeaver Repos
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/vscode.gpg >/dev/null
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
  wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/dbeaver.gpg
  echo "deb [signed-by=/etc/apt/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
  sudo apt update && sudo apt install -y code dbeaver-ce flatpak
  # Neovim
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && chmod u+x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim
  # Vesktop
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install flathub dev.vencord.Vesktop -y
}

# --- MAIN MENU ---
clear
echo -e "${GREEN}DEBIAN PROFESSIONAL DEPLOYMENT SYSTEM${NC}"
echo "1) Full Install (Desktop - NVIDIA/Picom/All Dev Tools)"
echo "2) Laptop Install (No NVIDIA/Picom)"
echo "3) Manual Selection"
read -p "Selection [1-3]: " mode

sudo apt update && sudo apt install -y rsync curl git wget apt-transport-https unzip build-essential lsb-release

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
  ask_user "Core Env?" && install_core
  ask_user "NVIDIA?" && install_nvidia
  ask_user "Audio?" && install_audio
  ask_user "Postgres?" && install_postgres
  ask_user "Node/PNPM?" && install_node
  ask_user "Docker?" && install_docker
  ask_user "Dev Apps?" && install_dev_apps
  ;;
esac

echo -e "\n${GREEN}Deployment finished! Please reboot.${NC}"

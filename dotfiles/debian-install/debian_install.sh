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
  if [ "$MANUAL_MODE" = false ]; then
    return 0
  fi
  echo -e "\n${BLUE}:: $1 [y/n]${NC}"
  read -r response
  [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
}

# --- FUNCTIONS ---

install_core() {
  echo -e "${GREEN}Configuring base environment and repositories...${NC}"
  sudo sed -i 's/main$/main contrib non-free non-free-firmware/' /etc/apt/sources.list
  sudo apt update

  # Base packages (Picom is now conditional)
  PACKAGES="bspwm sxhkd lightdm lightdm-gtk-greeter alacritty polybar feh nitrogen lxappearance firefox-esr i3lock-fancy xinit x11-xserver-utils zsh thunar kitty flameshot blueman x11-utils rofi"

  if [ "$INSTALL_PICOM" = true ]; then
    PACKAGES="$PACKAGES picom"
  fi

  sudo apt install -y $PACKAGES

  mkdir -p ~/.config ~/.local/share/fonts ~/images

  echo -e "${BLUE}Installing Iosevka Nerd Font...${NC}"
  URL_FONT="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.zip"
  wget -q --show-progress "$URL_FONT" -O /tmp/Iosevka.zip
  unzip -q /tmp/Iosevka.zip -d ~/.local/share/fonts/
  rm /tmp/Iosevka.zip
  fc-cache -fv

  echo -e "${BLUE}Installing Oh My Zsh...${NC}"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  echo -e "${BLUE}Restoring configurations...${NC}"
  # Copy all but exclude picom if necessary
  if [ -d "$BASE_DIR/.config" ]; then
    if [ "$INSTALL_PICOM" = true ]; then
      cp -r "$BASE_DIR/.config"/* ~/.config/
    else
      # Copy everything except the picom folder
      rsync -av --exclude='picom' "$BASE_DIR/.config/" ~/.config/
    fi
  fi

  [ -d "$BASE_DIR/images" ] && cp -r "$BASE_DIR/images"/* ~/images/
  [ -f "$BASE_DIR/.zshrc" ] && cp "$BASE_DIR/.zshrc" "$HOME/.zshrc"

  sudo chsh -s $(which zsh) $USER
}

install_nvidia() {
  echo -e "${GREEN}Installing official NVIDIA drivers...${NC}"
  sudo apt install -y linux-headers-$(uname -r) nvidia-driver firmware-misc-nonfree nvidia-settings nvidia-xconfig
  echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf
  sudo nvidia-xconfig
}

install_audio() {
  echo -e "${GREEN}Configuring Pipewire...${NC}"
  sudo apt install -y pipewire-audio-client-libraries pipewire-pulse \
    pipewire-alsa pipewire-jack wireplumber pavucontrol
  systemctl --user --now enable pipewire.service pipewire-pulse.service wireplumber.service
}

install_dev() {
  echo -e "${GREEN}Installing Dev Tools...${NC}"
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
  rm -f packages.microsoft.gpg
  wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/dbeaver.gpg
  echo "deb [signed-by=/etc/apt/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
  sudo apt update && sudo apt install -y code dbeaver-ce
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim
  sudo apt install -y flatpak
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install flathub dev.vencord.Vesktop -y
}

install_gaming() {
  echo -e "${GREEN}Configuring Gaming and Optimizations...${NC}"
  sudo dpkg --add-architecture i386
  sudo apt update
  sudo apt install -y steam mesa-vulkan-drivers mesa-vulkan-drivers:i386 zram-tools tlp
  sudo systemctl enable tlp
}

# --- MAIN MENU ---

clear
echo -e "${GREEN}DEBIAN PROFESSIONAL DEPLOYMENT SYSTEM${NC}"
echo "-----------------------------------------------------------"
echo -e "Choose your installation mode:"
echo -e "1) ${BLUE}Full Install (with NVIDIA & Picom)${NC}"
echo -e "2) ${BLUE}Full Install (No NVIDIA, No Picom - VM/Laptop)${NC}"
echo -e "3) ${BLUE}Manual Selection (Step-by-step)${NC}"
echo -e "4) Exit"
read -p "Selection [1-4]: " mode

# Setup rsync for exclusion logic
sudo apt update && sudo apt install -y rsync curl git wget apt-transport-https unzip build-essential

case $mode in
1)
  MANUAL_MODE=false
  INSTALL_PICOM=true
  install_core && install_nvidia && install_audio && install_dev && install_gaming
  ;;
2)
  MANUAL_MODE=false
  INSTALL_PICOM=false
  install_core && install_audio && install_dev && install_gaming
  ;;
3)
  MANUAL_MODE=true
  ask_user "Install Core Environment?" && {
    ask_user "Do you want to install Picom (Compositor)?" && INSTALL_PICOM=true || INSTALL_PICOM=false
    install_core
  }
  ask_user "Install NVIDIA Drivers?" && install_nvidia
  ask_user "Install Pipewire Audio?" && install_audio
  ask_user "Install Development Tools?" && install_dev
  ask_user "Install Gaming & Optimizations?" && install_gaming
  ;;
*)
  echo "Exiting..."
  exit 0
  ;;
esac

echo -e "\n${GREEN}Deployment finished! Please reboot your system.${NC}"

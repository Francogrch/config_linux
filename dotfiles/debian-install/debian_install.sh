#!/bin/bash

# --- CONFIGURACIÓN DINÁMICA ---
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

ask_user() {
  echo -e "\n${BLUE}:: $1 [s/n]${NC}"
  read -r response
  [[ "$response" =~ ^([sS][iI]|[sS])$ ]]
}

echo -e "${GREEN}DEBIAN PROFESSIONAL DEPLOYMENT SYSTEM${NC}"
echo "-----------------------------------------------------------"

# --- PREPARACIÓN ---
sudo apt update
sudo apt install -y software-properties-common curl git wget apt-transport-https unzip build-essential

# 1. CORE: ENTORNO, FUENTES Y ZSH
if ask_user "Instalar entorno base (bspwm, Iosevka, Zsh, Thunar, Kitty, Flameshot)?"; then
  echo -e "${GREEN}Configurando entorno base y repositorios...${NC}"
  sudo add-apt-repository contrib non-free non-free-firmware -y
  sudo apt update

  # Instalación de herramientas confirmadas
  sudo apt install -y bspwm sxhkd lightdm lightdm-gtk-greeter alacritty \
    polybar picom feh nitrogen lxappearance firefox-esr \
    i3lock-fancy xinit x11-xserver-utils zsh \
    thunar kitty flameshot blueman x11-utils rofi

  # Directorios base
  mkdir -p ~/.config ~/.local/share/fonts ~/images

  # --- Iosevka Nerd Font ---
  echo -e "${BLUE}Instalando Iosevka Nerd Font...${NC}"
  URL_FONT="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.zip"
  wget -q --show-progress "$URL_FONT" -O /tmp/Iosevka.zip
  unzip -q /tmp/Iosevka.zip -d ~/.local/share/fonts/
  rm /tmp/Iosevka.zip
  fc-cache -fv

  # --- Oh My Zsh ---
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  # --- Migración de archivos ---
  echo -e "${BLUE}Restaurando configuraciones desde el directorio local...${NC}"
  [ -d "$BASE_DIR/.config" ] && cp -r "$BASE_DIR/.config"/* ~/.config/
  [ -d "$BASE_DIR/images" ] && cp -r "$BASE_DIR/images"/* ~/images/
  [ -f "$BASE_DIR/.zshrc" ] && cp "$BASE_DIR/.zshrc" "$HOME/.zshrc"

  sudo chsh -s $(which zsh) $USER
fi

# 2. NVIDIA (RTX 3080)
if ask_user "Instalar drivers privativos de NVIDIA?"; then
  echo -e "${GREEN}Instalando controladores oficiales...${NC}"
  sudo apt install -y linux-headers-$(uname -r) nvidia-driver firmware-misc-nonfree nvidia-settings nvidia-xconfig
  echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf
  sudo nvidia-xconfig
fi

# 3. AUDIO: PIPEWIRE (Soporte nativo sin wpctl)
if ask_user "Instalar sistema de audio Pipewire (Compatible con pactl)?"; then
  echo -e "${GREEN}Configurando Pipewire...${NC}"
  sudo apt install -y pipewire-audio-client-libraries pipewire-pulse \
    pipewire-alsa pipewire-jack wireplumber pavucontrol
  # Habilitamos pipewire-pulse para que puedas usar comandos 'pactl' en sxhkd
  systemctl --user --now enable pipewire.service pipewire-pulse.service wireplumber.service
fi

# 4. DESARROLLO Y TOOLS
if ask_user "Instalar herramientas de desarrollo (VS Code, DBeaver, Neovim, Vesktop)?"; then
  # VS Code Oficial
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
  rm -f packages.microsoft.gpg
  # DBeaver
  wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/dbeaver.gpg
  echo "deb [signed-by=/etc/apt/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
  sudo apt update && sudo apt install -y code dbeaver-ce
  # Neovim AppImage
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim
  # Vesktop
  sudo apt install -y flatpak
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install flathub dev.vencord.Vesktop -y
fi

# 5. GAMING Y OPTIMIZACIONES
if ask_user "Instalar Steam y optimizaciones (Zram/TLP)?"; then
  sudo dpkg --add-architecture i386 && sudo apt update
  sudo apt install -y steam mesa-vulkan-drivers mesa-vulkan-drivers:i386 zram-tools tlp
  sudo systemctl enable tlp
fi

echo -e "\n${GREEN}¡Despliegue finalizado!${NC}"

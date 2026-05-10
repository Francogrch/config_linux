#!/bin/bash

# --- CONFIGURACIÓN DE COLORES ---
BACKUP_DIR="$HOME/backup"
RED='\033[0;31m'
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
sudo apt install -y software-properties-common curl git wget apt-transport-https unzip

# 1. CORE: ENTORNO BASE Y FUENTES (DESCARGA AUTOMÁTICA)
if ask_user "Instalar entorno base (bspwm, Iosevka Nerd Font, configs)?"; then
  echo -e "${GREEN}Configurando entorno base y repositorios...${NC}"
  sudo add-apt-repository contrib non-free non-free-firmware -y
  sudo apt update
  sudo apt install -y bspwm sxhkd lightdm lightdm-gtk-greeter alacritty \
    polybar picom feh nitrogen lxappearance firefox-esr \
    i3lock-fancy xinit x11-xserver-utils

  # Directorios base
  mkdir -p ~/.config ~/.local/share/fonts ~/images

  # --- Descarga e instalación de Iosevka Nerd Font ---
  echo -e "${BLUE}Descargando Iosevka Nerd Font desde GitHub...${NC}"
  URL_FONT="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.zip"
  wget -q --show-progress $URL_FONT -O /tmp/Iosevka.zip
  unzip -q /tmp/Iosevka.zip -d ~/.local/share/fonts/
  rm /tmp/Iosevka.zip
  fc-cache -fv
  echo -e "${GREEN}Fuentes instaladas correctamente.${NC}"

  # Migración de archivos de backup (configs e imágenes)
  if [ -d "$BACKUP_DIR" ]; then
    echo -e "${BLUE}Restaurando configuraciones desde backup...${NC}"
    [ -d "$BACKUP_DIR/.config" ] && cp -r "$BACKUP_DIR/.config"/* ~/.config/
    [ -d "$BACKUP_DIR/images" ] && cp -r "$BACKUP_DIR/images"/* ~/images/
  fi
fi'


# 2. NVIDIA: DRIVERS PRIVATIVOS
if ask_user "Instalar drivers privativos de NVIDIA (RTX 3080)?"; then
  echo -e "${GREEN}Instalando controladores oficiales de NVIDIA...${NC}"
  sudo apt install -y linux-headers-$(uname -r)
  sudo apt install -y nvidia-driver firmware-misc-nonfree nvidia-settings nvidia-xconfig
  echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf
  sudo nvidia-xconfig
fi

# 3. DESARROLLO: TOOLING
if ask_user "Instalar herramientas de desarrollo (VS Code, DBeaver, Vesktop, Neovim)?"; then
  echo -e "${GREEN}Configurando entorno de desarrollo...${NC}"

  # VS Code
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
  rm -f packages.microsoft.gpg

  # DBeaver
  wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/dbeaver.gpg
  echo "deb [signed-by=/etc/apt/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list

  sudo apt update
  sudo apt install -y code dbeaver-ce

  # Neovim AppImage
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim

  # Vesktop
  sudo apt install -y flatpak
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install flathub dev.vencord.Vesktop -y
fi

# 4. GAMING: STEAM
if ask_user "Instalar Steam?"; then
  sudo dpkg --add-architecture i386
  sudo apt update
  sudo apt install -y steam mesa-vulkan-drivers mesa-vulkan-drivers:i386
fi

# 5. OPTIMIZACIONES
if ask_user "Aplicar optimizaciones (Zram y TLP)?"; then
  sudo apt install -y zram-tools tlp
  sudo systemctl enable tlp
  echo -e "ALGO=lz4\nPERCENT=25" | sudo tee -a /etc/default/zramswap
  sudo service zramswap reload
fi

# 6. AUDIO: PIPEWIRE (Soporte profesional)
if ask_user "Instalar sistema de audio Pipewire (Recomendado para Vesktop/Canto)?"; then
  echo -e "${GREEN}Configurando Pipewire y WirePlumber...${NC}"
  sudo apt install -y pipewire-audio-client-libraries \
    pipewire-pulse pipewire-alsa pipewire-jack \
    wireplumber pavucontrol

  # Habilitar servicios para tu usuario
  systemctl --user --now enable wireplumber.service

  echo -e "${BLUE}Instalando controles de volumen...${NC}"
  # Pavucontrol es la interfaz gráfica para mover la cámara/mic entre dispositivos
  sudo apt install -y pavucontrol
fi

echo -e "\n${GREEN}Instalación terminada.${NC}"

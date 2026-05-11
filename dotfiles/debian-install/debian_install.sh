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
  echo -e "${GREEN}Configuring base environment and repositories...${NC}"

  # 1. CLEAN SOURCES.LIST (Full access for Trixie)
  sudo bash -c "cat <<EOF > /etc/apt/sources.list
deb http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware

deb http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
EOF"

  sudo apt update

  # All dependencies for your configs (sxhkdrc, bspwmrc, zshrc)
  PACKAGES="bspwm sxhkd lightdm lightdm-gtk-greeter alacritty polybar feh nitrogen lxappearance \
              firefox-esr i3lock-fancy xinit x11-xserver-utils zsh thunar kitty flameshot blueman \
              x11-utils rofi unzip fzf bat fd-find lsd zoxide tree zsh-autosuggestions \
              zsh-syntax-highlighting libfuse2t64 rsync vim vlc chromium libreoffice obs-studio \
              gnome-disk-utility easyeffects network-manager-gnome dunst lxpolkit xss-lock libnotify-bin"

  [ "$INSTALL_PICOM" = true ] && PACKAGES="$PACKAGES picom"
  sudo apt install -y $PACKAGES

  # Debian compatibility symlinks (for your fzf aliases)
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

  # Zsh Plugins & Themes
  echo -e "${BLUE}Installing Zsh Plugins and Themes...${NC}"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  # Path requested by your .zshrc
  sudo rm -rf /usr/share/zsh-autocomplete
  sudo git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git /usr/share/zsh-autocomplete

  # Restoration of Dotfiles
  echo -e "${BLUE}Restoring .config files...${NC}"
  mkdir -p ~/.config
  if [ "$INSTALL_PICOM" = true ]; then
    cp -r "$BASE_DIR/.config"/* ~/.config/
  else
    rsync -av --exclude='picom' "$BASE_DIR/.config/" ~/.config/
  fi

  echo -e "${BLUE}Setting execution permissions for scripts...${NC}"
  [ -d "$HOME/.config/bspwm/scripts" ] && chmod +x $HOME/.config/bspwm/scripts/*

  # Fix for Wallpapers and Zshrc
  mkdir -p ~/Pictures
  [ -d "$BASE_DIR/Pictures" ] && cp -r "$BASE_DIR/Pictures"/* ~/Pictures/
  [ -f "$BASE_DIR/.zshrc" ] && cp "$BASE_DIR/.zshrc" "$HOME/.zshrc"

  sudo chsh -s $(which zsh) $CURRENT_ACTUAL_USER
}

install_postgres() {
  echo -e "${GREEN}Installing PostgreSQL...${NC}"
  sudo apt install -y postgresql postgresql-contrib
  echo -e "\n${BLUE}PostgreSQL Configuration${NC}"
  read -p "Enter username for Postgres (root) (Default: $CURRENT_ACTUAL_USER): " PG_USER
  PG_USER=${PG_USER:-$CURRENT_ACTUAL_USER}
  read -sp "Set password for Postgres (example) user '$PG_USER': " PG_PASS
  echo ""
  sudo -u postgres psql -c "CREATE USER $PG_USER WITH PASSWORD '$PG_PASS' SUPERUSER;"
  sudo -u postgres psql -c "CREATE DATABASE $PG_USER OWNER $PG_USER;"
}

install_docker() {
  echo -e "${GREEN}Installing Docker and Docker Compose...${NC}"
  sudo apt install -y ca-certificates gnupg lsb-release
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker $CURRENT_ACTUAL_USER
}

install_node() {
  echo -e "${GREEN}Installing Node.js (fnm) and PNPM...${NC}"
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env)"
  fnm install --latest
  npm install -g pnpm
}

install_nvidia() {
  echo -e "${GREEN}Installing NVIDIA drivers (RTX 3080)...${NC}"
  sudo apt update
  sudo apt install -y linux-headers-$(uname -r) nvidia-driver firmware-misc-nonfree nvidia-settings nvidia-xconfig
  if command -v nvidia-xconfig >/dev/null; then
    echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf
    sudo nvidia-xconfig
  fi
}

install_audio() {
  echo -e "${GREEN}Configuring Pipewire...${NC}"
  sudo apt install -y pipewire-audio-client-libraries pipewire-pulse pipewire-alsa pipewire-jack wireplumber pavucontrol
  systemctl --user --now enable pipewire.service pipewire-pulse.service wireplumber.service
}

install_dev_apps() {
  echo -e "${GREEN}Installing Dev Apps (VS Code, DBeaver, Neovim, Postman)...${NC}"

  # VS Code (Fix: only main component)
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/vscode.gpg >/dev/null
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

  # DBeaver (Fix: only main component)
  wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/dbeaver.gpg
  echo "deb [signed-by=/etc/apt/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list

  sudo apt update && sudo apt install -y code dbeaver-ce flatpak

  # Neovim (Latest AppImage)
  sudo rm -f /usr/local/bin/nvim
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
  chmod +x nvim-linux-x86_64.appimage
  sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim

  # Flatpak apps
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install flathub dev.vencord.Vesktop com.getpostman.Postman -y
}

config_git() {
  echo -e "${GREEN}Configuring Git with conditional identities...${NC}"
  read -p "Enter your Global Git Name: " GIT_NAME
  read -p "Enter your PERSONAL email: " GIT_PERSONAL_EMAIL
  read -p "Enter your WORK email: " GIT_WORK_EMAIL

  git config --global user.name "$GIT_NAME"
  mkdir -p ~/Documents/personal ~/Documents/work

  echo -e "[user]\n\temail = $GIT_PERS" >~/.gitconfig-personal
  echo -e "[user]\n\temail = $GIT_WORK" >~/.gitconfig-work

  git config --global includeIf."gitdir:~/Documents/personal/".path "~/.gitconfig-personal"
  git config --global includeIf."gitdir:~/Documents/work/".path "~/.gitconfig-work"

  echo -e "${GREEN}Git identities configured! Personal: $GIT_PERSONAL_EMAIL | Work: $GIT_WORK_EMAIL${NC}"
}

# --- MAIN MENU ---
clear
echo -e "${GREEN}DEBIAN PROFESSIONAL DEPLOYMENT SYSTEM${NC}"
echo "-----------------------------------------------------------"
echo "1) Full Install (Desktop - NVIDIA/Picom/Database/All)"
echo "2) Laptop Install (No NVIDIA/Picom)"
echo "3) Manual Selection"
echo "4) Exit"
read -p "Selection [1-4]: " mode

sudo apt update && sudo apt install -y rsync curl git wget apt-transport-https unzip build-essential lsb-release

case $mode in
1)
  MANUAL_MODE=false
  INSTALL_PICOM=true
  install_core && install_nvidia && install_audio && install_postgres && install_node && install_docker && install_dev_apps && config_git
  ;;
2)
  MANUAL_MODE=false
  INSTALL_PICOM=false
  install_core && install_audio && install_postgres && install_node && install_docker && install_dev_apps && config_git
  ;;
3)
  MANUAL_MODE=true
  ask_user "Core Env?" && install_core
  ask_user "NVIDIA?" && install_nvidia
  ask_user "Audio?" && install_audio
  ask_user "Postgres?" && install_postgres
  ask_user "Node?" && install_node
  ask_user "Docker?" && install_docker
  ask_user "Dev Apps?" && install_dev_apps
  ask_user "Configure Git?" && config_git
  ;;
*) exit 0 ;;
esac

echo -e "\n${GREEN}Deployment finished! Please reboot to apply all changes. (systemctl reboot) ${NC}"

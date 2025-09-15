#!/bin/bash
function check_root() {
  if [ "$EUID" -eq 0 ]; then
    echo "No ejecutes este script como root. Por favor, ejecútalo como un usuario normal con privilegios de sudo."
    exit 1
  fi
}

function print_welcome() {
  echo "========================================"
  echo "   Script de Instalación de Entorno    "
  echo "            Arch Linux                 "
  echo "========================================"
  echo "
    █████████                   █████       ███            
  ███░░░░░███                 ░░███       ░░░             
  ░███    ░░░   ██████   █████  ░███████   ████            
  ░░█████████  ███░░███ ███░░   ░███░░███ ░░███            
  ░░░░░░░░███░███ ░███░░█████  ░███ ░███  ░███            
  ███    ░███░███ ░███ ░░░░███ ░███ ░███  ░███            
  ░░█████████ ░░██████  ██████  ████ █████ █████           
  ░░░░░░░░░   ░░░░░░  ░░░░░░  ░░░░ ░░░░░ ░░░░░            
                                                          
                                                          
                                                          
  ███████████ █████                                       
  ░█░░░███░░░█░░███                                        
  ░   ░███  ░  ░███████    ██████  █████████████    ██████ 
      ░███     ░███░░███  ███░░███░░███░░███░░███  ███░░███
      ░███     ░███ ░███ ░███████  ░███ ░███ ░███ ░███████ 
      ░███     ░███ ░███ ░███░░░   ░███ ░███ ░███ ░███░░░  
      █████    ████ █████░░██████  █████░███ █████░░██████ 
    ░░░░░    ░░░░ ░░░░░  ░░░░░░  ░░░░░ ░░░ ░░░░░  ░░░░░░
  "

  echo "Bienvenido al script de instalacion de mi entorno de trabajo en Arch Linux."
  echo "Este script instalara los paquetes basicos, configurara el entorno de trabajo y habilitara los servicios necesarios."
  echo "Asegurate de estar conectado a internet y de tener privilegios de sudo."
  echo "Presiona Enter para continuar..."
  read

  clear
}

function install() {
  local packages_to_install=("$@")
  if [[ ${#packages_to_install[@]} -gt 0 ]]; then
    sudo pacman -S --noconfirm "${packages_to_install[@]}"
    echo "Instalación completada."
  else
    echo "No se especificaron paquetes para instalar."
  fi
}

function paquetes_adicionales() {
  read -p "Quieres instalar los paquetes de bluetooth? (y/N)" confirm
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    install bluez bluez-utils
  fi

  read -p "Quieres instalar los paquetes de edicion de imagen y video? (y/N)" confirm
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    install kdenlive gimp obs-studio
  fi

  read -p "Quieres instalar los paquetes de ofimatica? (y/N)" confirm
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    install libreoffice-fresh
  fi

  read -p "Quieres instalar los paquetes de virtualizacion? (y/N)" confirm
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    install virtualbox virtualbox-host-modules-arch
    sudo modprobe vboxdrv
    sudo gpasswd -a $USER vboxusers
  fi

  read -p "Quieres instalar los paquetes de redes? (y/N)" confirm
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    install networkmanager network-manager-applet
  fi

  read -p "Quieres instalar los paquetes de gaming? (y/N)" confirm
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    install steam lutris
  fi
}

function enable_services() {
  systemctl --user enable pulseaudio.service
  sudo systemctl enable bluetooth.service
  sudo systemctl enable lightdm.service
  sudo chown -R "$USER":"$USER" "$HOME/"
}

function copy_dotfiles() {
  mkdir -p "$HOME/.config"
  cp -rf ./dotfiles/.config/* "$HOME/.config"
  cp -rf ./dotfiles/.xsettingsd "$HOME/"
  mkdir -p "$HOME/Pictures"
  cp ./dotfiles/Pictures/wallpaper.png "$HOME/Pictures"
  cp ./dotfiles/Pictures/wallpaper.jpg "$HOME/Pictures"
  chmod +x "$HOME/.config/bspwm/bspwmrc"
  chmod +x "$HOME/.config/sxhkd/sxhkdrc"
  mkdir -p "$HOME/.local/share/icons/dunst"
  cp ./dotfiles/icons/* "$HOME/.local/share/icons/dunst"
}

function install_zsh_config() {
  install zsh zoxide zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting fzf bat tree fd lsd
  rm -rf "$HOME/.oh-my-zsh"
  clear
  echo "Cuando termine de instalar Oh My Zsh, escribe exit para cerrar la terminal y volver a este script."
  read -p "Presiona Enter para continuar..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  clear
  cp -rf ./dotfiles/.zshrc "$HOME/"
}

# Instalacion
check_root
print_welcome
sudo pacman -Syu
read -p "Actualizacion completada. Presiona Enter para continuar..."
clear

read -p "Quieres instalar los paquetes basicos? (y/N)" confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  install git base-devel vim neovim wget htop ripgrep fastfetch zip unzip xclip xdotool man-db xdg-user-dirs xorg-xrandr lightdm lightdm-gtk-greeter bspwm sxhkd picom feh dunst polybar alacritty kitty rofi thunar firefox viewnior maim pulseaudio pulsemixer pulseaudio-alsa xsettingsd materia-gtk-theme papirus-icon-theme redshift polkit-gnome xcolor
fi
read -p "Instalacion de paquetes basicos completada. Presiona Enter para continuar..."
clear

read -p "Quieres instalar algun paquete adicional? (y/N)" confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  paquetes_adicionales
fi

echo "¡Instalación de paquetes completada!"
read -p "Presiona Enter para continuar..."
clear

enable_services

echo "¡Servicios habilitados!"
read -p "Presiona Enter para continuar..."
clear

copy_dotfiles

echo "¡Instalación de dotfiles completada!"
read -p "Presiona Enter para continuar..."
clear

echo "¡Instalando Fuentes!"
install ttf-iosevka-nerd ttf-jetbrains-mono noto-fonts-emoji ttf-nerd-fonts-symbols ttf-firacode-nerd ttf-hack-nerd
echo "¡Instalación de fuentes completada!"
read -p "Presiona Enter para continuar..."
clear

read -p "Quieres instalar mi zsh personal? (y/N)" confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  install_zsh_config
  echo "¡Instalación de zsh completada!"
fi

echo "Instalacion completada. Presiona cualquier tecla para reiniciar. ¡Disfruta de tu nuevo entorno! :)"
read -n 1 -s
sudo reboot

#!/bin/bash
clear
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
# Comandos de instalacion con sudo
sudo pacman -Syu
read -p "Actualizacion completada. Presiona Enter para continuar..."
clear
read -p "Quieres instalar los paquetes basicos? (y/n)" confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  sudo pacman -S --noconfirm git base-devel vim neovim wget htop ripgrep fastfetch zip unzip xclip xdotool man-db xdg-user-dirs xorg-xrandr lightdm lightdm-gtk-greeter bspwm sxhkd picom feh dunst polybar alacritty kitty rofi thunar firefox viewnior maim pulseaudio pulsemixer pulseaudio-alsa xsettingsd materia-gtk-theme papirus-icon-theme redshift polkit-gnome xcolor
fi
read -p "Instalacion completada. Presiona Enter para continuar..."
clear

read -p "Quieres instalar los paquetes de bluetooth? (y/n)" confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  sudo pacman -S --noconfirm bluez bluez-utils
fi

echo "¡Instalación de paquetes completada!"
read -p "Presiona Enter para continuar..."
clear
# Habilitar servicios con sudo
systemctl --user enable pulseaudio.service
sudo systemctl enable bluetooth.service
sudo systemctl enable lightdm.service
sudo chown -R "$USER":"$USER" "$HOME/"

echo "¡Servicios habilitados!"
read -p "Presiona Enter para continuar..."
clear
# Comandos de configuracion de usuario (sin sudo)
mkdir -p "$HOME/.config"
cp -rf ./dotfiles/.config/* "$HOME/.config"
cp -rf ./dotfiles/.xsettingsd "$HOME/"
mkdir -p "$HOME/Pictures"
cp ./dotfiles/Pictures/wallpaper.png "$HOME/Pictures"
chmod +x "$HOME/.config/bspwm/bspwmrc"
chmod +x "$HOME/.config/sxhkd/sxhkdrc"
mkdir -p "$HOME/.local/share/icons/dunst"
cp ./dotfiles/icons/* "$HOME/.local/share/icons/dunst"

echo "¡Instalación de dotfiles completada!"
read -p "Presiona Enter para continuar..."
clear
sudo pacman -S --noconfirm ttf-iosevka-nerd ttf-jetbrains-mono noto-fonts-emoji ttf-nerd-fonts-symbols ttf-firacode-nerd ttf-hack-nerd
echo "¡Instalación de fuentes completada!"
read -p "Presiona Enter para continuar..."
clear

read -p "Quieres instalar mi zsh personal? (y/n)" confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  sudo pacman -S --noconfirm zsh zoxide zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting fzf bat tree fd
  rm -rf "$HOME/.oh-my-zsh"
  clear
  echo "Cuando termine de instalar Oh My Zsh, escribe exit para cerrar la terminal y volver a este script."
  read -p "Presiona Enter para continuar..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  clear
  cp -rf ./dotfiles/.zshrc "$HOME/"
  echo "¡Instalación de zsh completada!"
fi

echo "Instalacion completada. Presiona cualquier tecla para reiniciar. ¡Disfruta de tu nuevo entorno! :)"
read -n 1 -s
sudo reboot

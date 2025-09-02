#!/bin/bash

# Este script necesita permisos de root para algunas instalaciones.
echo "--Theme Soshi Installer--."
echo "Se necesita permisos de root para algunas instalaciones."
read -p "Presiona Enter para continuar..."

# Se solicita la contraseña de sudo una sola vez
sudo echo "Permisos concedidos. La instalacion continuara."

# Comandos de instalacion con sudo
sudo pacman -Syyu
sudo pacman -Sy git base-devel vim wget alacritty kitty rofi thunar polybar nvim firefox xclip pulseaudio zip unzip zsh zsh-autosuggestions zsh-syntax-highlighting htop man lightdm lightdm-gtk-greeter bspwm sxhkd picom feh xorg-xrandr bluez bluez-utils pulseaudio-alsa pulsemixer xsettingsd material-gtk-theme vesktop redshift papirus-icon-theme xcolor

# Habilitar servicios con sudo
sudo systemctl --user enable pulseaudio.service
sudo systemctl enable bluetooth.service
sudo systemctl enable lightdm.service

# Comandos de configuracion de usuario (sin sudo)
mkdir -p ~/.config
cp -rf .config/* ~/.config/
cp -rf .zshrc ~/
cp -rf .xsettingsd ~/
mkdir -p ~/Documents
cp wallpaper.jpg ~/Documents
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/sxhkd/sxhkdrc
unzip fuentes.zip -d ~/.local/share/fonts/
fc-cache -fv

# Instalar fuentes
mkdir -p ~/.local/share/fonts
wget 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Iosevka.zip' -O /tmp/Iosevka.zip &&
  unzip /tmp/Iosevka.zip -d ~/.local/share/fonts/ &&
  wget 'https://github.com/FortAwesome/Font-Awesome/releases/download/6.5.2/fontawesome-free-6.5.2-desktop.zip' -O /tmp/fontawesome.zip &&
  unzip /tmp/fontawesome.zip -d ~/.local/share/fonts/ &&
  wget 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip' -O /tmp/JetBrainsMono.zip &&
  unzip /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -fv

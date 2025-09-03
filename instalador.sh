#!/bin/bash

# Este script necesita permisos de root para algunas instalaciones.
echo "--Theme Soshi Installer--."
echo "Se necesita permisos de root para algunas instalaciones."
read -p "Presiona Enter para continuar..."

# Se solicita la contraseña de sudo una sola vez
sudo echo "Permisos concedidos. La instalacion continuara."

# Comandos de instalacion con sudo
sudo pacman -Syyu

echo "Quieres instalar los paquetes basicos? (y/n)"
sudo pacman -Sy git base-devel vim neovim wget htop ripgrep zip unzip xclip xdotool man xdg-user-dirs xorg-xrandr lightdm lightdm-gtk-greeter bspwm sxhkd picom feh dunst polybar alacritty kitty rofi thunar firefox vesktop viewnior maim pulseaudio pulsemixer pulseaudio-alsa xsettingsd material-gtk-theme papirus-icon-theme redshift polkit-gnome xcolor

echo "Quieres instalar los paquetes de bluetooth? (y/n)"
sudo pacman -Sy bluez bluez-utils

# Habilitar servicios con sudo
sudo systemctl --user enable pulseaudio.service
sudo systemctl enable bluetooth.service
sudo systemctl enable lightdm.service
sudo chown -R "$USER":"$USER" ~/

# Comandos de configuracion de usuario (sin sudo)
mkdir -p ~/.config
cp -rf .config/* ~/.config/
cp -rf .xsettingsd ~/
mkdir -p ~/Documents
cp wallpaper.jpg ~/Documents
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/sxhkd/sxhkdrc
mkdir -p ~/.local/share/icons/dunst
cp icons/* ~/.local/share/icons/dunst

#unzip fuentes.zip -d ~/.local/share/fonts/
#fc-cache -fv

# Instalar fuentes
mkdir -p ~/.local/share/fonts
wget 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Iosevka.zip' -O /tmp/Iosevka.zip &&
  unzip /tmp/Iosevka.zip -d ~/.local/share/fonts/ &&
  wget 'https://github.com/FortAwesome/Font-Awesome/releases/download/6.5.2/fontawesome-free-6.5.2-desktop.zip' -O /tmp/fontawesome.zip &&
  unzip /tmp/fontawesome.zip -d ~/.local/share/fonts/ &&
  wget 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip' -O /tmp/JetBrainsMono.zip &&
  unzip /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -fv

# Instalacion de zsh
#
sudo pacman -S zsh zoxide zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting fzf bat tree fd
# Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp -rf .zshrc ~/
chsh -s /bin/zsh

echo "Instalacion completada. Reinicia el sistema para aplicar todos los cambios. ¡Disfruta de tu nuevo entorno! 🎉"

#!/bin/bash

# Este script necesita permisos de root para algunas instalaciones.
echo "--Theme Soshi Installer--."
echo "Se necesita permisos de root para algunas instalaciones."
read -p "Presiona Enter para continuar..."

# Se solicita la contraseña de sudo una sola vez
sudo echo "Permisos concedidos. La instalacion continuara."

# Comandos de instalacion con sudo
sudo pacman -Syyu

read -p "Quieres instalar los paquetes basicos? (y/n)" confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  sudo pacman -S --noconfirm git base-devel vim neovim wget htop ripgrep zip unzip xclip xdotool man-db xdg-user-dirs xorg-xrandr lightdm lightdm-gtk-greeter bspwm sxhkd picom feh dunst polybar alacritty kitty rofi thunar firefox viewnior maim pulseaudio pulsemixer pulseaudio-alsa xsettingsd materia-gtk-theme papirus-icon-theme redshift polkit-gnome xcolor
fi

read -p "Quieres instalar los paquetes de bluetooth? (y/n)" confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  sudo pacman -S --noconfirm bluez bluez-utils
fi

echo "¡Instalación de paquetes completada!"
read -p "Presiona Enter para continuar..."
# Habilitar servicios con sudo
systemctl --user enable pulseaudio.service
sudo systemctl enable bluetooth.service
sudo systemctl enable lightdm.service
sudo chown -R "$USER":"$USER" "$HOME/"

echo "¡Servicios habilitados!"
read -p "Presiona Enter para continuar..."
# Comandos de configuracion de usuario (sin sudo)
mkdir -p "$HOME/.config"
cp -rf ./dotfiles/.config/* "$HOME/.config"
cp -rf ./dotfiles/.xsettingsd "$HOME/"
mkdir -p "$HOME/Pictures"
cp ./dotfiles/Pictures/wallpaper.jpg "$HOME/Pictures"
chmod +x "$HOME/.config/bspwm/bspwmrc"
chmod +x "$HOME/.config/sxhkd/sxhkdrc"
mkdir -p "$HOME/.local/share/icons/dunst"
cp ./dotfiles/icons/* "$HOME/.local/share/icons/dunst"

echo "¡Instalación de dotfiles completada!"
read -p "Presiona Enter para continuar..."
#mkdir -p "$HOME/.local/share/fonts"
sudo pacman -S ttf-iosevka-nerd ttf-jetbrains-mono noto-fonts-emoji ttf-nerd-fonts-symbols ttf-firacode-nerd ttf-hack-nerd
#unzip fuentes.zip -d "$HOME/.local/share/fonts/"
#fc-cache -fv
# Instalar fuentes
# mkdir -p "$HOME/.local/share/fonts"
# wget 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Iosevka.zip' -O /tmp/Iosevka.zip &&
#   unzip /tmp/Iosevka.zip -d "$HOME/.local/share/fonts/" &&
#   wget 'https://github.com/FortAwesome/Font-Awesome/releases/download/6.5.2/fontawesome-free-6.5.2-desktop.zip' -O /tmp/fontawesome.zip &&
#   unzip /tmp/fontawesome.zip -d "$HOME/.local/share/fonts/" &&
#   wget 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip' -O /tmp/JetBrainsMono.zip &&
#   unzip /tmp/JetBrainsMono.zip -d "$HOME/.local/share/fonts/"
# fc-cache -fv
#
echo "¡Instalación de fuentes completada!"
read -p "Presiona Enter para continuar..."

# Instalacion de zsh
sudo pacman -S zsh zoxide zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting fzf bat tree fd
# Oh My Zsh
rm -rf "$HOME/.oh-my-zsh"
echo "Cuando termine de instalar Oh My Zsh, pon exit para cerrar la terminal y volver a este script."
read -p "Presiona Enter para continuar..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp -rf ./dotfiles/.zshrc "$HOME/"
chsh -s /bin/zsh

echo "¡Instalación de zsh completada!"

echo "Instalacion completada. Reinicia el sistema para aplicar todos los cambios. ¡Disfruta de tu nuevo entorno! 🎉"

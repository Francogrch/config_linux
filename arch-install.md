# Instalacion de archinstall

## 1. Instalación de Arch Linux

    archinstall

Perfil: Minimal
Network configuration: Copy ISO network configuration to installation

## 2. Configuración Inicial

```bash
# Actualizar el sistema
sudo pacman -Syyu

sudo pacman -S git base-devel vim wget

sudo pacman -S lightdm lightdm-gtk-greeter

sudo systemctl enable lightdm.service

sudo pacman -Sy bspwm sxhkd picom feh xorg-xrandr

# Copiar configuracion
mkdir -p ~/.config/{bspwm,sxhkd}
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/

chmod +x ~/.config/bspwm/bspwmrc

sudo pacman -S alacritty kitty rofi thunar polybar nvim firefox xclip polkit-gnome pulseaudio zip wget unzip

sudo pacman -S zsh zsh-autosuggestions zsh-syntax-highlighting htop htop man

sudo pacman -S bluez bluez-utils pulseaudio pulseaudio-alsa

systemctl --user enable pulseaudio.service
systemctl --user start pulseaudio.service
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
# Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

.zshrc
# Zsh Autocompletado
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Resaltado de Sintaxis
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

chsh -s /bin/zsh

reboot

# Bateria
sudo pacman -S xfce4-power-manager
#acomodar bspwmrc


#Fuente

mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Iosevka.zip
unzip Iosevka.zip -d ~/.local/share/fonts/
fc-cache -fv

curl -L -o fontawesome-free.zip "https://github.com/FortAwesome/Font-Awesome/releases/download/6.5.2/fontawesome-free-6.5.2-desktop.zip"
unzip fontawesome-free.zip -d ~/.local/share/fonts/
fc-cache -fv

sudo chown -R <your_user_name>:<your_user_name> ~/.config
```

configuracion copiarda .config

- kitty - listo
- alacritty - listo
- nvim - falta
- bspwm - listo
- sxhkd - falta
- polybar - falta
- rofi - falta
- picom - falta
- feh - listo
- zsh - listo
- thunar - nol

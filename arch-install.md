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

sudo pacman -Sy bspwm sxhkd picom feh

# Copiar configuracion
mkdir -p ~/.config/{bspwm,sxhkd}
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/

chmod +x ~/.config/bspwm/bspwmrc

sudo pacman -S alacritty kitty rofi thunar polybar nvim firefox xclip

sudo pacman -S zsh zsh-autosuggestions zsh-syntax-highlighting htop htop



# Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

.zshrc
# Zsh Autocompletado
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Resaltado de Sintaxis
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

chsh -s /bin/zsh

reboot


```

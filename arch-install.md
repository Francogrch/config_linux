# Instalacion de archinstall

## 1. Instalación de Arch Linux

    archinstall

Recordar seleccionar:

- Perfil: Minimal
- Network configuration: Copy ISO network configuration to installation

## 2. Configuración Inicial (instalador.sh)

```bash
sudo pacman -Syyu
sudo pacman -Sy git base-devel vim wget
sudo pacman -Sy lightdm lightdm-gtk-greeter bspwm sxhkd picom feh xorg-xrandr
sudo pacman -Sy alacritty kitty rofi thunar polybar nvim firefox xclip polkit-gnome pulseaudio zip wget unzip htop htop man
sudo pacman -Sy bluez bluez-utils pulseaudio pulsemixer pulseaudio-alsa xsettingsd material-gtk-theme vesktop redshift papirus-icon-theme xcolor
sudo systemctl --user enable pulseaudio.service
sudo systemctl enable bluetooth.service
sudo systemctl enable lightdm.service

# Copiar configuracion
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

#Fuente
mkdir -p ~/.local/share/fonts
wget 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Iosevka.zip' -O /tmp/Iosevka.zip && \
unzip /tmp/Iosevka.zip -d ~/.local/share/fonts/ && \
wget 'https://github.com/FortAwesome/Font-Awesome/releases/download/6.5.2/fontawesome-free-6.5.2-desktop.zip' -O /tmp/fontawesome.zip && \
unzip /tmp/fontawesome.zip -d ~/.local/share/fonts/ && \
wget 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip' -O /tmp/JetBrainsMono.zip && \
unzip /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -fv


```

## 3. Configuración de Zsh y Oh My Zsh

```bash

pacman -S zsh zoxide zsh-autocomplete-git bat tree zsh-autosuggestions zsh-syntax-highlighting
# Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Plugins
# Fzf junto con ohmyzsh
git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
sed -i 's/^plugins=(.*)/plugins=(fzf-zsh-plugin \1)/' ~/.zshrc

echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
echo "source /path/to/zsh-autocomplete/zsh-autocomplete.plugin.zsh" >> ~/.zshrc
echo 'ZSH_THEME="muse"' >> ~/.zshrc
# Alias
alias v="nvim"
alias fzfp='fzf --preview="bat --theme=gruvbox-dark --color=always {}"'
alias fzfv='nvim $(fzf --preview="bat --theme=gruvbox-dark --color=always {}")'
alias fzfcd='cd "$(fd --type d --hidden --exclude .git | fzf --preview="tree -C {} | head -100")"'


source ~/.zshrc

# Cambiar shell a zsh
chsh -s /bin/zsh

reboot

# Bateria/ Pantalla laptop
sudo pacman -S xfce4-power-manager

sudo chown -R <your_user_name>:<your_user_name> ~/.config
```

## 4.Configuracion de programas

Picom: Linea 153 - cambiar a glx si la tarjeta grafica lo soporta

configuracion copiarda .config

- nvim - falta
- picom - listo
- rofi - listo
- polybar - listo
- kitty - listo
- alacritty - listo
- bspwm - listo
- sxhkd - listo
- feh - listo
- zsh - listo
- thunar - listo
- .zshrc - listo
- .xsettingsd - listo
- redshift - listo

## 5. Backup

```bash
sudo pacman -S rsync
```

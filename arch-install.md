# Instalacion de archinstall

## 1. Instalación de Arch Linux

    archinstall

Recordar seleccionar:

- Perfil: Minimal
- Network configuration: Copy ISO network configuration to installation

Por ultimo Reboot system

## 2. Configuración Inicial (instalador.sh)

```bash
sudo pacman -Syu
sudo pacman -S git
git clone https:github.com/Francogrch/config_arch.git
cd config_arch
chmod +x install.sh
./install.sh
```

```bash

# Sincroniza la lista de paquetes para tener la información más reciente

sudo pacman -Syyu
# --- GRUPO 1: Entorno de desarrollo y utilidades del sistema ---
sudo pacman -S git base-devel vim neovim wget htop ripgrep zip unzip xclip xdotool man xdg-user-dirs

# --- GRUPO 2: Entorno gráfico y gestor de ventanas ---
sudo pacman -S xorg-xrandr lightdm lightdm-gtk-greeter bspwm sxhkd picom feh dunst polybar

# --- GRUPO 3: Aplicaciones de escritorio y productividad ---
sudo pacman -S alacritty kitty rofi thunar firefox vesktop viewnior maim

# --- GRUPO 4: Sonido, apariencia y periféricos ---
sudo pacman -S pulseaudio pulsemixer pulseaudio-alsa xsettingsd material-gtk-theme papirus-icon-theme redshift polkit-gnome xcolor

# --- GRUPO 5: Herramientas adicionales ---
sudo pacman -S bluez bluez-utils

sudo systemctl enable lightdm.service
sudo systemctl --user enable pulseaudio.service
sudo systemctl enable bluetooth.service


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
mkdir -p ~/.local/share/icons/dunst
cp icons/* ~/.local/share/icons/dunst
fc-cache -fv

# Fuente
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
pacman -S zsh zoxide zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting fzf bat tree fd
# Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Configuracion Oh My Zsh
echo 'ZSH_THEME="muse"' >> ~/.zshrc
alias v="nvim"
alias fzfp='fzf --preview="bat --theme=gruvbox-dark --color=always {}"'
alias fzfv='nvim $(fzf --preview="bat --theme=gruvbox-dark --color=always {}")'
alias fzfcd='cd "$(fd --type d --hidden --exclude .git | fzf --preview="tree -C {} | head -100")"'

# Plugins
sed -i 's/^plugins=(/plugins=(fzf' ~/.zshrc
echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
echo "source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh" >> ~/.zshrc
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
source ~/.zshrc

# Cambiar shell a zsh
chsh -s /bin/zsh

reboot

# Bateria/ Pantalla laptop
sudo pacman -S xfce4-power-manager light backlight

sudo chown -R "$USER":"$USER" ~/
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

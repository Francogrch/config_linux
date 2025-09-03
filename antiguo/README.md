# **Configuración de Arch Linux (Dotfiles)**

Repositorio con la configuración de mi sistema operativo Arch Linux, usando BSPWM como gestor de ventanas.

## **Temas para ArchCraft**

Las carpetas `escritorio .config` y `notebook .config` contienen configuraciones específicas para diferentes máquinas (PC de escritorio y notebook). Están pensadas para ser usadas como "temas" o perfiles completos para el sistema, principalmente sobre ArchCraft.

ArchCraft <3

## **Post-Instalación: Guía de Configuración**

Esta guía detalla los pasos a seguir después de una instalación base de Arch Linux para dejar el entorno completamente configurado.

### **1. Conexión Wi-Fi**

Pasos para conectarse a la red desde la terminal.

```bash
# Activar Wi-Fi
nmcli r wifi on

# Listar redes disponibles
nmcli d wifi list

# Conectarse a una red
nmcli d wifi connect "SSID" password "PASSWORD"
```

### **2. Sistema Gráfico y Paquetes Esenciales**

Instalación del gestor de sesión, el gestor de ventanas y utilidades básicas.

```bash
# Instalar gestor de sesión
sudo pacman -S lightdm lightdm-gtk-greeter
# Configurar lightdm
# En /etc/lightdm/lightdm.conf, descomentar y editar:
# greeter-session=lightdm-gtk-greeter
sudo systemctl enable lightdm.service

# Instalar paquetes principales
sudo pacman -S bspwm sxhkd nitrogen picom rofi thunar iw neofetch htop btop alacritty brightnessctl conky wget arandr pulsemixer git polybar zsh nvim lsd bat zsh-autosuggestions zathura
```

### **3. Configuración del Entorno (BSPWM y SXHKD)**

Pasos para configurar las variables de entorno y los archivos iniciales del gestor de ventanas.

```bash
# Crear y exportar la variable XDG_CONFIG_HOME en ~/.xprofile
echo 'export XDG_CONFIG_HOME="$HOME/.config"' >> ~/.xprofile

# Configurar bspwm y sxhkd para que inicien con la sesión en ~/.xprofile
echo 'sxhkd &' >> ~/.xprofile
echo 'exec bspwm' >> ~/.xprofile

# Crear directorios y copiar configuraciones de ejemplo
mkdir -p ~/.config/{bspwm,sxhkd}
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/

# Añadir atajo para abrir la terminal en ~/.config/sxhkd/sxhkdrc
# super + Return
#     alacritty
```

### **4. Configuración de la Shell (Zsh)**

```bash
# Cambiar la shell por defecto a Zsh
chsh -s /bin/zsh

# Instalar Oh My Zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Instalar tema Powerlevel10k
yay -S --noconfirm zsh-theme-powerlevel10k-git

# Instalar plugins (Syntax Highlighting y Autosuggestions)
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
```

### **5. Utilidades y Aplicaciones**

#### **AUR Helper (yay)**

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
```

#### **Fuentes**

```bash
# Mover fuentes a la carpeta del sistema (ajusta la ruta de origen)
sudo mv fonts/* /usr/share/fonts/TTF

# Configurar fuente en Alacritty (ejemplo en alacritty.yml)
# font:
#   normal:
#     family: "MesloLGS NF"
```

#### **Rofi**

```bash
# Crear directorios para temas de Rofi
mkdir -p ~/.local/share/rofi/themes

# Mover temas (ajusta la ruta de origen)
# mv spotlight-dark.rasi ~/.local/share/rofi/themes/
```

#### **Software Adicional**

```bash
# Ofimática
yay -S onlyoffice-bin

# Editor de código
yay -S visual-studio-code-bin

# Eclipse (requiere Java)
sudo pacman -S jdk11-openjdk
# Luego descargar y ejecutar el instalador de Eclipse
```

### **6. Configuración de Neovim**

#### **Opción 1: Mi Configuración Personal (LazyVim)**

Esta es la configuración personal que se encuentra en este repositorio. Para usarla, simplemente copia la carpeta `nvim` a tu directorio de configuración.

```bash
# Reemplaza tu configuración actual con la de este repositorio
cp -r .config/nvim ~/.config/
```

#### **Opción 2: LunarVim**

```bash
# Instalar dependencias
sudo pacman -S git make python python-pip npm nodejs cargo

# Instalar LunarVim
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)

# Dentro de Neovim, ejecutar:
# :LvimUpdate
# :LvimSyncCorePlugins
```

#### **Opción 3: NvChad**

```bash
# Clonar configuración de NvChad
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim

# Dentro de Neovim, ejecutar:
# :NvChadUpdate
```

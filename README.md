# Entorno de Escritorio Personal para Arch Linux <3

Este repositorio contiene mi configuración personal para un entorno de escritorio minimalista y funcional en Arch Linux, utilizando **bspwm** como gestor de ventanas. El script de instalación automatiza la mayor parte del proceso.

![wallpaper](./dotfiles/Pictures/wallpaper.jpg)

## Características

- **Gestor de Ventanas (WM):** bspwm
- **Lanzador de Aplicaciones:** Rofi
- **Terminal:** Alacritty & Kitty
- **Editor de Texto:** Neovim (con una configuración predefinida)
- **Barra de Estado:** Polybar
- **Shell:** Zsh con Oh My Zsh, autocompletado y resaltado de sintaxis.
- **Temas:** Tema Materia GTK y iconos Papirus.

## Instalación

La instalación se realiza en dos fases: la instalación base de Arch Linux y la ejecución de mi script personal para configurar el entorno.

### 1. Instalación de Arch Linux

Se recomienda una instalación mínima de Arch Linux. Puedes usar el instalador oficial `archinstall`.

- **Perfil de Instalación:** `minimal`
- **Autenticación:** Crea un usuario con permisos `sudo` y establece una contraseña para `root`.
- **Configuración de Red:** Selecciona `Copy ISO network configuration to installation` para mantener la conexión a internet después de reiniciar.

Una vez finalizada la instalación, reinicia el sistema e inicia sesión con tu usuario.

#### Conexión Wi-Fi (Opcional)

Si perdiste la conexión a internet, puedes reconectarte desde la terminal:

```bash
# Activar la interfaz Wi-Fi
nmcli r wifi on

# Listar redes disponibles
nmcli d wifi list

# Conectarse a una red (reemplaza "SSID" y "PASSWORD")
nmcli d wifi connect "SSID" password "PASSWORD"
```

### 2. Instalación del Entorno Personal

El siguiente script clonará este repositorio e instalará todos los paquetes y configuraciones necesarios.

```bash
# Actualizar el sistema e instalar git
sudo pacman -Syu --noconfirm
sudo pacman -S git --noconfirm

# Clonar el repositorio y ejecutar el script
git clone https://github.com/Francogrch/config_arch.git
cd config_arch
chmod +x install.sh
./install.sh
```

El script te guiará a través de la instalación. Al finalizar, el sistema se reiniciará automáticamente.

## Paquetes Instalados

El script `install.sh` instalará los siguientes paquetes, organizados por categoría:

### Sistema y Utilidades Base

- **`base-devel`**: Herramientas esenciales para compilación.
- **`git`**: Control de versiones.
- **`wget`**: Descarga de archivos desde la red.
- **`htop`**: Monitor de procesos interactivo.
- **`ripgrep`**: Herramienta de búsqueda de texto.
- **`fastfetch`**: Información del sistema.
- **`zip`**, **`unzip`**: Compresión y descompresión de archivos.
- **`xclip`**: Interfaz de línea de comandos para el portapapeles.
- **`xdotool`**: Automatización de entrada (teclado/ratón).
- **`man-db`**: Manuales de sistema.
- **`xdg-user-dirs`**: Gestión de directorios de usuario (Descargas, Documentos, etc.).
- **`polkit-gnome`**: Agente de autenticación para PolicyKit.

### Entorno Gráfico (X11)

- **`xorg-xrandr`**: Configuración de pantalla y resolución.
- **`lightdm`**, **`lightdm-gtk-greeter`**: Gestor de inicio de sesión y tema GTK.
- **`bspwm`**: Gestor de ventanas de mosaico.
- **`sxhkd`**: Demonio de atajos de teclado para X.
- **`picom`**: Compositor para efectos visuales (transparencias, sombras).
- **`feh`**: Visor de imágenes y gestor de fondos de pantalla.
- **`dunst`**: Demonio de notificaciones.
- **`xsettingsd`**: Demonio para propagar configuraciones de GTK.
- **`xcolor`**: Selector de color.

### Aplicaciones de Usuario

- **`alacritty`**, **`kitty`**: Emuladores de terminal modernos.
- **`rofi`**: Lanzador de aplicaciones y menús.
- **`polybar`**: Barra de estado.
- **`thunar`**: Gestor de archivos.
- **`firefox`**: Navegador web.
- **`viewnior`**: Visor de imágenes.
- **`maim`**: Utilidad para capturas de pantalla.
- **`neovim`**, **`vim`**: Editores de texto.

### Audio y Multimedia

- **`pulseaudio`**, **`pulsemixer`**, **`pulseaudio-alsa`**: Servidor de sonido y controles.

### Temas y Apariencia

- **`materia-gtk-theme`**: Tema GTK.
- **`papirus-icon-theme`**: Tema de iconos.
- **`redshift`**: Ajusta la temperatura de color de la pantalla.

### Fuentes

- `ttf-iosevka-nerd`
- `ttf-jetbrains-mono`
- `noto-fonts-emoji`
- `ttf-nerd-fonts-symbols`
- `ttf-firacode-nerd`
- `ttf-hack-nerd`

### Shell (Zsh) y Herramientas de Línea de Comandos

- **`zsh`**: Shell Z.
- **`zoxide`**: Navegación inteligente de directorios.
- **`zsh-autocomplete`**, **`zsh-autosuggestions`**, **`zsh-syntax-highlighting`**: Plugins para mejorar la experiencia en la shell.
- **`fzf`**: Buscador difuso de línea de comandos.
- **`bat`**: Un `cat` con resaltado de sintaxis y Git.
- **`tree`**: Muestra la estructura de directorios en forma de árbol.
- **`fd`**: Alternativa simple y rápida a `find`.

### Bluetooth (Opcional)

- **`bluez`**, **`bluez-utils`**: Pila de protocolos de Bluetooth.

## Configuraciones Adicionales

### bspwm (`~/.config/bspwm/bspwmrc`)

- **Línea 15**: Descomenta o comenta para habilitar o deshabilitar el inicio automático de `picom`.
- **Línea 35**: Define la resolución de tu pantalla principal.
- **Línea 77**: Ajusta los nombres y la cantidad de monitores según tu configuración.

### Picom (`~/.config/picom/picom.conf`)

- **Línea 153**: Puedes cambiar el backend a `glx` si tu tarjeta gráfica ofrece mejor rendimiento con él.

### Neovim

La primera vez que abras `nvim`, los plugins se instalarán automáticamente. No se requiere ninguna acción adicional.

## Backup

El repositorio incluye un script para realizar copias de seguridad de tus archivos de configuración.

1.  **Instalar rsync:**
    ```bash
    sudo pacman -S rsync
    ```
2.  **Ejecutar el script:**
    El archivo `antiguo/scripts/list_back.txt` contiene la lista de archivos y carpetas que se copiarán.
    ```bash
    ./antiguo/scripts/backup.sh
    ```

# Instalacion de Arch Linux con configuracion personal

## 1. Instalacion de configuracion personal

### 1.0 Conexión Wi-Fi (**opcional**)

Pasos para conectarse a una red wifi desde la terminal.

```bash
# Activar Wi-Fi
nmcli r wifi on

# Listar redes disponibles
nmcli d wifi list

# Conectarse a una red
nmcli d wifi connect "SSID" password "PASSWORD"
```

### 1.1 Instalación de Arch Linux

    archinstall

Recordar:

- Perfil: Minimal
- Autentication: Password root y crear un usuario con permisos sudo
- Network configuration: Copy ISO network configuration to installation
- Reboot system

### 1.2 Instalación de la configuración

Es necesario iniciar sesion como un usuario normal, no como root

```bash
sudo pacman -Syu
sudo pacman -S git
git clone https://github.com/Francogrch/config_arch.git
cd config_arch
chmod +x install.sh
./install.sh
```

### 1.3 Configuraciones adicionales

#### Paquetes adicionales

```bash

# Bateria/ Pantalla laptop
sudo pacman -S xfce4-power-manager light backlight
```

#### bspwm

- Linea 15: comentar si no quieres que inicie picom automaticamente
- Linea 35: definir resolucion de pantalla
- Linea 77: definir cantidad de monitores

#### Picom:

- Linea 153: cambiar a glx si la tarjeta grafica lo soporta

## 2. Paquetes que instala el script

### 2.1 Plugins de zsh

```bash

```

## 5. Backup

En la carpeta scripts hay un script para hacer copia de los archivos/carpetas que esten definidos en list_back.txt

```bash
sudo pacman -S rsync
./script/backup.sh
```

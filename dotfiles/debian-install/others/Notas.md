## Paso a paso instalacion debian con opciones a seleccionar

- Language: English
- Time Zone: other -> South America -> Argentina
- Keyboard: United State (en_US.UTF-8)
- Keymap to use: us

- Hostname: (your hostname)
- Domain name: (your domain)
- Root password: (your root password)
- Create a user: (your username)
- Full name: (your full name)
- Username: (your username)
- Password: (your password)

- Partition disks: Guided - use entire disk
- Partition disks: Separate /home partition (10% for (/,swap)  and 90% for /home)
- Finish partitioning and write changes to disk: Yes

- Scan extra instalation media: No
- Mirror Country: Argentina
- Mirror: deb.debian.org

- Software selection: standard system utilities

- Install the GRUB boot loader on a hard disk: Yes
- Device for boot loader installation: /dev/sdX

## En la tty
``` bash

su -
apt update && sudo apt upgrade -y
apt install sudo
usermod -aG sudo <userName>
reboot

sudo apt install git curl -y

git clone <>

cd config_linux/dotfiles/debian-install 
chmod +x debian_install.sh
./debian_install.sh
```

## Cosas que faltan




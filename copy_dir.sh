#!/bin/bash

# Definir las rutas originales de las carpetas
declare -A folders=(
    ["Polybar"]="/home/soshi/.config/polybar"
    ["Rofi"]="/home/soshi/.config/rofi"
    ["bspwm"]="/home/soshi/.config/bspwm"
    ["sxhkd"]="/home/soshi/.config/sxhkd"
    ["alacritty"]="/home/soshi/.config/alacritty"
    ["kitty"]="/home/soshi/.config/kitty"
    ["zsh"]="/home/soshi/.zshrc"
    ["oh-my-zsh"]="/home/soshi/.oh-my-zsh"
    ["picom"]="/home/soshi/.config/picom"
)

# Ruta destino (carpeta actual)
destination="$(pwd)"

# Copiar las carpetas
for folder in "${!folders[@]}"; do
    echo "Copiando $folder a $destination"
    cp -r "${folders[$folder]}" "$destination"
done

echo "¡Copia de carpetas completada!"


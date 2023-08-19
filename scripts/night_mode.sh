#!/bin/bash

monitor="DP-0"  # Cambia esto al identificador de tu monitor

# Verifica el estado actual del modo noche
current_gamma=$(xrandr --verbose | grep -A 10 "$monitor" | grep -oP 'Gamma:      \K.{11}')
echo $curent_gamma

if [[ $current_gamma == "1.0:1.0:1.0" ]]; then
    # Cambiar a modo noche
    xrandr --output "$monitor" --gamma 1.0:0.88:0.76 --brightness 0.9
    echo "Modo Noche Activado para el monitor $monitor"
else
    # Cambiar a modo normal
    xrandr --output "$monitor" --gamma 1.0:1.0:1.0 --brightness 1.0
    echo "Modo Noche Desactivado para el monitor $monitor"
fi


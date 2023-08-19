#!/bin/bash

# Obtener la lista de dispositivos de salida de audio disponibles
devices=$(pactl list sinks | awk '/Name: /{print $2}')

# Agregar la opción "Cambiar a la salida anterior"
devices+=" Cambiar a la salida anterior"

# Mostrar el menú Rofi y obtener la selección del usuario
selected_device=$(echo -e "$devices" | rofi -dmenu -p "Selecciona un dispositivo de audio:")

if [ "$selected_device" == "Cambiar a la salida anterior" ]; then
    # Cambiar a la salida de audio anterior
    pactl set-default-sink "$(pactl info | awk '/Default Sink: /{print $3}')"
else
    # Cambiar al dispositivo de audio seleccionado
    pactl set-default-sink "$selected_device"
fi


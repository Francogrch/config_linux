#!/bin/bash
# Ajuste para tu DP-1 (165Hz) y HDMI-A-1 (Secundario)
# Los nombres exactos los sacás de correr 'xrandr' en la terminal
xrandr --output DP-0 --primary --mode 1920x1080 --rate 165 --pos 1920x0 --rotate normal \
       --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal

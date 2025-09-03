#!/bin/zsh

# Función para configurar la resolución manualmente
configure_resolution_manually() {
    echo "Ingresa los valores de resolución manualmente:"
    echo "Ingresa el valor de height: "
    read height
    echo "Ingresa el valor de width: "
    read width
    h=$(( (1920 - height) / 2 ))
    w=$(( (1080 - width) / 2 ))
}

# Menú para elegir entre varias resoluciones o configurar manualmente
echo "Menú de resoluciones:"
echo "1. 1920x1080"
echo "2. 1280x960"
echo "3. 1152x864"
echo "4. 1024x768"
echo "5. 1708x960 (24')"
echo "6. Configurar manualmente"
echo "Elige una opción (1/2/3/4/5/6): "
read option

# Ejecutar el comando con las resoluciones seleccionadas
case $option in
    1)
        height=1920
        width=1080
        h=0
        w=0
        ;;
    2)
        height=1280
        width=960
        h=320
        w=60
        ;;
    3)
        height=1152
        width=864
        h=384
        w=108
        ;;
    4)
        height=1024
        width=768
        h=448
        w=156
        ;;
    5)
        height=1708 
        width=960
        h=106
        w=60
        ;;
    6)
        configure_resolution_manually
        ;;
    *)
        echo "Opción inválida. Saliendo."
        exit 1
        ;;
esac

#Ejecutar el comando con las variables ingresadas por el usuario

nvidia-settings --assign CurrentMetaMode="HDMI-0:1920x1080 ,DP-0: 1920x1080_165 { ViewPortIn=1920x1080,ViewPortOut=${height}x${width}+${h}+${w} }"


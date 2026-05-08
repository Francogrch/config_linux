#!/usr/bin/env bash

dir="$HOME/.config/polybar"
themes=(`ls --hide="launch.sh" $dir`)

launch_bar() {
    killall -q polybar
    while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

    for mon in $(polybar --list-monitors | cut -d":" -f1); do
        TEMP_CONF="/tmp/polybar_$mon.ini"
        
        # REEMPLAZA la línea 'monitor =' por el monitor real en la copia temporal
        sed "s/^monitor =.*$/monitor = $mon/" "$dir/$style/config.ini" > "$TEMP_CONF"

        if [[ "$style" == "hack" || "$style" == "cuts" ]]; then
            polybar -q top -c "$TEMP_CONF" &
            polybar -q bottom -c "$TEMP_CONF" &
        else
            # Lanza las tres opciones comunes; las que no existan fallarán silenciosamente
            polybar -q main -c "$TEMP_CONF" &
            polybar -q top -c "$TEMP_CONF" &
            polybar -q bottom -c "$TEMP_CONF" &
        fi
    done
}

if [[ "$1" == "--material" ]]; then
	style="material"
	launch_bar

elif [[ "$1" == "--shades" ]]; then
	style="shades"
	launch_bar

elif [[ "$1" == "--hack" ]]; then
	style="hack"
	launch_bar

elif [[ "$1" == "--docky" ]]; then
	style="docky"
	launch_bar

elif [[ "$1" == "--cuts" ]]; then
	style="cuts"
	launch_bar

elif [[ "$1" == "--shapes" ]]; then
	style="shapes"
	launch_bar

elif [[ "$1" == "--grayblocks" ]]; then
	style="grayblocks"
	launch_bar

elif [[ "$1" == "--blocks" ]]; then
	style="blocks"
	launch_bar

elif [[ "$1" == "--colorblocks" ]]; then
	style="colorblocks"
	launch_bar

elif [[ "$1" == "--forest" ]]; then
	style="forest"
	launch_bar

else
	cat <<- EOF
	Usage : launch.sh --theme
		
	Available Themes :
	--blocks    --colorblocks    --cuts      --docky
	--forest    --grayblocks     --hack      --material
	--shades    --shapes
	EOF
fi

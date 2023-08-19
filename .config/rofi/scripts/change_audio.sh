#!/usr/bin/env bash
 
source $HOME/scripts/audio_constants.sh
 
# THEME="$HOME/.config/polybar/nord_narrow.rasi"
 
SPEAKERS=" Speakers"
HEADPHONES=" Headphones"
BLUETOOTH=" Bluetooth"
 
OPTIONS="$SPEAKERS\n$HEADPHONES\n$BLUETOOTH"
 
ACTIVE_OUTPUT=$($HOME/.config/polybar/get_active_output.sh)
case $ACTIVE_OUTPUT in
    "Speakers")
        SELECTED_ROW=0
    ;;
    "Headset")
        SELECTED_ROW=1
    ;;
    "Bluetooth")
        SELECTED_ROW=2
    ;;
    *)
        SELECTED_ROW=0
    ;;
esac
 
SELECTION=$(echo -e $OPTIONS | rofi -font "Source Code Pro Medium 14" -mesg "Select audio output" -dmenu -selected-row $SELECTED_ROW -yoffset -435 -xoffset 500)
 
echo $SELECTION
 
case $SELECTION in
    $SPEAKERS)
        pactl set-default-sink $DOCK_SINK
      ;;
    $HEADPHONES)
        # set output to headphones
        pactl set-default-sink $HEADPHONES_SINK
        # set input to headset mic
        # pactl set-source-port $HEADPHONES_SOURCE_PORT
    ;;
    $BLUETOOTH)
        # set a2dp profile (high quality audio)
        pactl set-card-profile $BT_CARD a2dp_sink
        pactl set-default-sink $BT_SINK
    ;;
    *)
        echo "nothing to do"
esac

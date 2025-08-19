# ------------------------------------------------------------------------------
# Copyright (C) 2020-2024 Aditya Shakya <adi1090x@gmail.com>
#
# Beach Theme
# ------------------------------------------------------------------------------

# Colors
background='#1E1E2E'
foreground='#CDD6F4'
color0='#45475A'
color1='#F38BA8'
color2='#A6E3A1'
color3='#F9E2AF'
color4='#89B4FA'
color5='#F5C2E7'
color6='#94E2D5'
color7='#BAC2DE'
color8='#585B70'
color9='#F38BA8'
color10='#A6E3A1'
color11='#F9E2AF'
color12='#89B4FA'
color13='#F5C2E7'
color14='#94E2D5'
color15='#A6ADC8'
accent='#F5E0DC'
element_bg='#EEFFFF'
element_fg='#303030'

# Light and Dark values (valores de luz y oscuridad)
light_value='0.15'
dark_value='0.30'

# Wallpaper
wdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
wallpaper="$wdir/wallpaper"

# Polybar
polybar_font='Iosevka:size=12;3'

# Rofi
rofi_font='Iosevka 12'
rofi_icon='Zafiro'

# Terminal
terminal_font_name='JetBrainsMono Nerd Font'
terminal_font_size='12'

# Geany
geany_colors='arc.conf'
geany_font='JetBrainsMono Nerd Font 10'

# Appearance
gtk_font='Noto Sans 9'
gtk_theme='Windows-10-Dark'
icon_theme='Win11-Dark'
cursor_theme='Bibata'

# Dunst
dunst_width='300'
dunst_height='80'
dunst_offset='20x58'
dunst_origin='bottom-right'
dunst_font='Iosevka Custom 9'
dunst_border='2'
dunst_separator='2'

# Picom
picom_backend='glx'
picom_corner='0'
picom_shadow_r='20'
picom_shadow_o='0.60'
picom_shadow_x='-20'
picom_shadow_y='-20'
picom_blur_method='none'
picom_blur_strength='0'

# Bspwm
bspwm_fbc="$accent"
bspwm_nbc="$background"
bspwm_abc="$color5"
bspwm_pfc="$color2"
bspwm_border='2'
bspwm_gap='10'
bspwm_sratio='0.50'

# 1. Obtener nombres de los monitores conectados (omite los desconectados)
# Esto extrae solo la primera palabra de las líneas que dicen ' connected'
MONITORS=($(xrandr | grep " connected" | awk '{print $1}'))

# 2. Lógica de configuración
if [ ${#MONITORS[@]} -eq 2 ]; then
  # CASO: DOS MONITORES (Escritorio)
  # Buscamos cuál es el DP (usualmente el de 165Hz) y cuál el HDMI
  PRIMARY=""
  SECONDARY=""

  for m in "${MONITORS[@]}"; do
    if [[ $m == DP* ]]; then
      PRIMARY=$m
    elif [[ $m == HDMI* ]]; then
      SECONDARY=$m
    fi
  done

  # Si no detectó nombres con DP/HDMI específicos, usa el orden de detección
  PRIMARY=${PRIMARY:-${MONITORS[0]}}
  SECONDARY=${SECONDARY:-${MONITORS[1]}}

  echo "Configurando Dual Setup: Principal ($PRIMARY) y Secundario ($SECONDARY)"

  # Intentamos poner el principal a 165Hz (si falla, xrandr bajará a la máxima disponible)
  xrandr --output "$PRIMARY" --primary --mode 1920x1080 --rate 165 --pos 1920x0 --rotate normal \
    --output "$SECONDARY" --mode 1920x1080 --pos 0x0 --rotate normal

elif [ ${#MONITORS[@]} -eq 1 ]; then
  # CASO: UN MONITOR (Notebook o PC con un solo cable)
  echo "Configurando Monitor Único: ${MONITORS[0]}"
  xrandr --output "${MONITORS[0]}" --primary --mode 1920x1080 --pos 0x0 --rotate normal
else
  # CASO: Falla de detección o más de 2 monitores
  xrandr --auto
fi

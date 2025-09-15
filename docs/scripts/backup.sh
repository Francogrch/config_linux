#!/bin/bash
clear
echo "
  █████████                   █████       ███            
 ███░░░░░███                 ░░███       ░░░             
░███    ░░░   ██████   █████  ░███████   ████            
░░█████████  ███░░███ ███░░   ░███░░███ ░░███            
 ░░░░░░░░███░███ ░███░░█████  ░███ ░███  ░███            
 ███    ░███░███ ░███ ░░░░███ ░███ ░███  ░███            
░░█████████ ░░██████  ██████  ████ █████ █████           
 ░░░░░░░░░   ░░░░░░  ░░░░░░  ░░░░ ░░░░░ ░░░░░            
                                                         
                                                         
                                                         
 ███████████ █████                                       
░█░░░███░░░█░░███                                        
░   ░███  ░  ░███████    ██████  █████████████    ██████ 
    ░███     ░███░░███  ███░░███░░███░░███░░███  ███░░███
    ░███     ░███ ░███ ░███████  ░███ ░███ ░███ ░███████ 
    ░███     ░███ ░███ ░███░░░   ░███ ░███ ░███ ░███░░░  
    █████    ████ █████░░██████  █████░███ █████░░██████ 
   ░░░░░    ░░░░ ░░░░░  ░░░░░░  ░░░░░ ░░░ ░░░░░  ░░░░░░
"

echo "--- Utilidad de Backup Automatizado ---"
echo "Este script realiza un backup de archivos y directorios listados en 'list_back.txt'."
echo "Utiliza 'rsync' para una sincronización eficiente y diferencial."
echo ""
echo "Asegúrese de que el archivo 'list_back.txt' exista en la misma ubicación que este script y de tener los permisos necesarios."
echo "Por favor, ingresa la ruta de la carpeta de destino para el backup:"

read -r DESTINO
#DESTINO="/ruta/a/la/carpeta/de/backup"

LISTA="./list_back.txt"

# --- Verificación y ejecución ---

if [ ! -d "$DESTINO" ]; then
  echo "La carpeta de destino '$DESTINO' no existe. Creando..."
  mkdir -p "$DESTINO"
fi

if [ ! -f "$LISTA" ]; then
  echo "Error: El archivo de lista '$LISTA' no existe."
  exit 1
fi

echo "Iniciando el proceso de backup..."
while read -r ORIGEN; do
  # Ignorar líneas vacías y comentarios (líneas que empiezan con #).
  if [ -z "$ORIGEN" ] || [[ "$ORIGEN" =~ ^# ]]; then
    continue
  fi

  eval "ORIGEN=\"$ORIGEN\""
  if [ ! -e "$ORIGEN" ]; then
    echo "Advertencia: El origen '$ORIGEN' no existe. Saltando."
    continue
  fi

  # -a (archive) preserva permisos, propietario, grupo y fechas.
  # -v (verbose) muestra el progreso en la consola.
  echo "Copiando: '$ORIGEN' a '$DESTINO'..."
  rsync -avR "$ORIGEN" "$DESTINO"

done <"$LISTA"

echo "¡Backup completado con éxito! 🎉"

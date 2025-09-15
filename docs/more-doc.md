# Documentación Adicional del Entorno

Este documento complementa el `README.md` principal y tiene como objetivo aclarar conceptos clave, explicar el rol de los componentes principales y guiar en la personalización del entorno.

## 1. Filosofía del Entorno

La elección de las herramientas en esta configuración no es aleatoria. Se basa en una filosofía que prioriza:

-   **Minimalismo:** Utilizar aplicaciones ligeras y eficientes que consuman pocos recursos.
-   **Control por Teclado:** La mayoría de las acciones, desde mover ventanas hasta lanzar aplicaciones, están diseñadas para ser ejecutadas con el teclado. Esto aumenta la velocidad y la eficiencia una vez que te acostumbras a los atajos.
-   **Personalización y Control:** Cada componente es altamente configurable. Tienes el control total sobre la apariencia y el comportamiento de tu escritorio.
-   **Modularidad:** El sistema se construye a partir de pequeñas herramientas que trabajan juntas. Si no te gusta un componente (por ejemplo, la barra de estado), puedes reemplazarlo sin romper el resto del sistema.

## 2. Componentes Clave del Entorno

Para un recién llegado, es útil entender qué hace cada pieza del rompecabezas:

| Componente | Rol en el Entorno                                                                                             | Archivo de Configuración Principal                               |
| :--------- | :------------------------------------------------------------------------------------------------------------ | :--------------------------------------------------------------- |
| **bspwm**  | Es el **gestor de ventanas** (*Window Manager*). Su trabajo es organizar las ventanas en un diseño de mosaico (tiling) de forma automática. No tiene una configuración interna; se controla a través de comandos externos. | `~/.config/bspwm/bspwmrc`                                        |
| **sxhkd**  | Es el **demonio de atajos de teclado**. Captura las pulsaciones de teclas (ej. `super + d`) y ejecuta los comandos correspondientes (ej. lanzar `rofi`). Es el cerebro que controla `bspwm` y lanza aplicaciones. | `~/.config/sxhkd/sxhkdrc`                                        |
| **Polybar**| Es la **barra de estado**. Muestra información útil como los espacios de trabajo, la hora, el estado de la red, el volumen, etc. Es altamente personalizable a través de módulos. | `~/.config/polybar/config.ini` y `~/.config/polybar/launch.sh`   |
| **Rofi**   | Es un **lanzador de aplicaciones y conmutador de ventanas**. Se utiliza para abrir programas, cambiar entre ventanas abiertas y ejecutar menús personalizados (como el de apagado o el de bluetooth). | `~/.config/rofi/`                                                |
| **Picom**  | Es el **compositor**. Se encarga de los efectos visuales como las transparencias, las sombras de las ventanas y las animaciones. Ayuda a que el entorno se vea más moderno y pulido. | `~/.config/picom/picom.conf`                                     |
| **Dunst**  | Es el **gestor de notificaciones**. Muestra las notificaciones del sistema (por ejemplo, cuando subes el volumen o recibes un mensaje) de una manera minimalista y configurable. | `~/.config/dunst/dunstrc`                                        |
| **Feh**    | Aunque es un visor de imágenes, en esta configuración su rol principal es **establecer el fondo de pantalla** al inicio de la sesión. | Se llama desde `~/.config/bspwm/bspwmrc`                         |

## 3. Guía Post-Instalación y Personalización

### a. Configurar Monitores y Resolución

El archivo `bspwmrc` está configurado para una resolución y un número de monitores específicos. Si tu configuración es diferente, necesitarás ajustarla.

1.  **Identifica tus monitores:** Abre una terminal y ejecuta el comando `xrandr`. La salida te mostrará los nombres de tus monitores conectados (ej. `eDP-1`, `HDMI-1`, `DP-1`).

2.  **Ajusta `bspwmrc`:** Edita el archivo `~/.config/bspwm/bspwmrc`.
    -   Busca la línea que contiene `xrandr --output ...` y ajústala a tu resolución.
    -   Busca la línea `bspc monitor -d ...` y modifica los nombres y el número de escritorios virtuales para cada uno de tus monitores.

    **Ejemplo para dos monitores (portátil y externo):**
    ```bash
    # ~/.config/bspwm/bspwmrc

    # Configura la resolución de cada pantalla
    xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-1 --primary --mode 1920x1080 --pos 1920x0 --rotate normal

    # Asigna escritorios a cada monitor
    bspc monitor eDP-1 -d I II III IV V
    bspc monitor HDMI-1 -d VI VII VIII IX X
    ```

3.  **Ajusta Polybar:** Si tienes más de un monitor, querrás que la barra aparezca en ambos. Edita `~/.config/polybar/launch.sh` para lanzar una barra por cada monitor detectado.

### b. Personalizar el Script de Backup

El script de backup (`docs/scripts/backup.sh`) utiliza `rsync` para copiar los archivos y carpetas listados en `docs/scripts/list_back.txt`.

Para añadir tus propios archivos a la copia de seguridad, simplemente edita `docs/scripts/list_back.txt` y añade la ruta completa de los archivos o carpetas que quieras incluir.

### c. Cambiar Temas y Apariencia

-   **Tema GTK e Iconos:** Para cambiar el tema de las aplicaciones con interfaz gráfica (como Thunar), puedes instalar `lxappearance` (`sudo pacman -S lxappearance`). Esta herramienta te permitirá seleccionar y aplicar temas GTK e iconos de forma sencilla.
-   **Tema de Rofi:** Los temas de Rofi se gestionan en `~/.config/rofi/`. Puedes editar los archivos `.rasi` para cambiar colores y estilos.
-   **Colores de Polybar:** Los colores de la barra se definen en `~/.config/polybar/colors.ini`.

## 4. Uso del AUR con `yay`

El script de instalación te ofrece instalar `yay`. `yay` es un "AUR Helper", una herramienta para interactuar con el **Arch User Repository (AUR)**.

El AUR es un repositorio gestionado por la comunidad que contiene miles de paquetes que no están en los repositorios oficiales de Arch Linux (por ejemplo, `google-chrome`, `spotify`, `visual-studio-code-bin`).

### Comandos Básicos de `yay`

-   **Instalar un paquete:**
    ```bash
    yay -S nombre-del-paquete
    ```

-   **Buscar un paquete en el AUR:**
    ```bash
    yay nombre-del-paquete
    ```

-   **Actualizar todos los paquetes (oficiales y del AUR):**
    ```bash
    yay -Syu
    ```
    O simplemente `yay` sin argumentos.

-   **Eliminar un paquete:**
    ```bash
    yay -Rns nombre-del-paquete
    ```

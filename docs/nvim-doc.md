# Mi Configuración de Neovim (LazyVim)

Una configuración de Neovim moderna y rápida basada en LazyVim, optimizada para el desarrollo y personalizada para una experiencia de usuario fluida y eficiente.

## 1. Captura de Pantalla

_(Aquí puedes insertar una captura de pantalla de tu configuración en acción para mostrar el tema, la barra de estado y la apariencia general.)_

![placeholder](https://via.placeholder.com/800x450.png?text=Mi+Neovim+Config)

## 2. Características Principales

- **Gestor de Plugins:** Basado en `Lazy.nvim` para una carga perezosa y un inicio ultrarrápido.
- **LSP (Language Server Protocol):** Autocompletado, diagnósticos y navegación de código con `mason.nvim` y `nvim-lspconfig`.
- **Autocompletado:** Potente motor de completado con `nvim-cmp`, integrado con LSP, snippets y buffers.
- **Buscador (Fuzzy Finder):** Búsqueda de archivos, buffers, texto y más con `Telescope.nvim`.
- **Interfaz de Usuario:** Una UI limpia y funcional con `lualine` (barra de estado), `bufferline` (pestañas de buffers) y el tema `Catppuccin`.
- **Integración con Git:** Manejo de Git directamente en el editor con `gitsigns.nvim`.
- **Resaltado de Sintaxis:** Resaltado avanzado y preciso con `nvim-treesitter`.
- **Terminal Integrada:** Acceso rápido a una terminal flotante con `toggleterm.nvim`.

## 3. Prerrequisitos

Para que esta configuración funcione correctamente, necesitas tener instalado lo siguiente:

- **Neovim:** `v0.9.0` o superior.
- **Git:** Para clonar la configuración y para que LazyVim funcione.
- **Nerd Font:** Necesario para que los iconos se muestren correctamente (ej. JetBrains Mono Nerd Font, Fira Code Nerd Font).
- **Herramientas Externas:**
  - `ripgrep`: Requerido por Telescope para la búsqueda de texto.
  - Un compilador de C (como `gcc`) para `nvim-treesitter`.
  - **Formateadores:** `stylua` (para Lua), `isort` y `black` (para Python), `prettier` (para web).

## 4. Instalación

Sigue estos pasos para instalar la configuración:

1.  **Hacer una copia de seguridad de tu configuración actual (recomendado):**

    ```bash
    mv ~/.config/nvim ~/.config/nvim.bak
    mv ~/.local/share/nvim ~/.local/share/nvim.bak
    ```

2.  **Clonar este repositorio en la ubicación de configuración de Neovim:**

    ```bash
    # Asumiendo que este repo está en `~/config_linux`
    ln -s ~/config_linux/dotfiles/.config/nvim ~/.config/nvim
    ```

    O si prefieres copiarlo directamente:

    ```bash
    cp -r ~/config_linux/dotfiles/.config/nvim ~/.config/
    ```

3.  **Iniciar Neovim:**
    ```bash
    nvim
    ```
    Al iniciar por primera vez, LazyVim se instalará automáticamente y sincronizará todos los plugins definidos.

## 5. Estructura de la Configuración

La configuración está organizada siguiendo las convenciones de LazyVim para una fácil gestión:

- `init.lua`: El punto de entrada principal. Carga `lazy.nvim` y las configuraciones principales.
- `lua/config/`: Contiene los archivos de configuración base.
  - `lazy.lua`: La configuración de `lazy.nvim`, donde se importan todos los plugins.
  - `maps.lua`: Atajos de teclado (keymaps) globales.
  - `settings.lua`: Opciones globales de Neovim (`vim.opt`).
- `lua/plugins/`: El corazón de la configuración. Cada archivo `.lua` en este directorio define la configuración de uno o más plugins.

## 6. Atajos de Teclado (Keymaps)

**Tecla Líder:** `<Space>`

| Atajo                                 | Descripción                                                   |
| :------------------------------------ | :------------------------------------------------------------ |
| **Gestión de Archivos y Buffers**     |                                                               |
| `<C-s>`                               | Guardar el archivo actual.                                    |
| `<leader>q`                           | Cerrar Neovim.                                                |
| `L`                                   | Ir al siguiente buffer.                                       |
| `H`                                   | Ir al buffer anterior.                                        |
| `<leader>e`                           | Alternar el explorador de archivos (NeoTree).                 |
| `<leader>r`                           | Enfocar el explorador de archivos (NeoTree).                  |
| **Navegación y Edición**              |                                                               |
| `jk`                                  | Salir del modo de inserción.                                  |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Moverse entre ventanas (izquierda/abajo/arriba/derecha).      |
| `<leader>o`                           | Crear una nueva ventana vertical.                             |
| `<leader>p`                           | Crear una nueva ventana horizontal.                           |
| **Telescope (Buscador)**              |                                                               |
| `<leader>ff`                          | Buscar archivos.                                              |
| `<leader>fg`                          | Buscar en archivos (live grep).                               |
| `<leader>fb`                          | Buscar buffers abiertos.                                      |
| `<leader>fh`                          | Buscar etiquetas de ayuda.                                    |
| **Autocompletado (nvim-cmp)**         |                                                               |
| `<C-Space>`                           | Activar el autocompletado.                                    |
| `<C-e>`                               | Cancelar el autocompletado.                                   |
| `<CR>`                                | Confirmar la selección.                                       |
| `<C-b>` / `<C-f>`                     | Desplazarse en la documentación (arriba/abajo).               |
| **Formateo (Conform)**                |                                                               |
| `<leader>f`                           | Formatear el archivo o el rango (en modo visual).             |
| **Terminal (Toggleterm)**             |                                                               |
| `<F7>`                                | Alternar la terminal flotante.                                |
| **Git (Gitsigns)**                    |                                                               |
| `]c` / `[c`                           | Ir al siguiente/anterior hunk de git.                         |
| `<leader>hs`                          | Guardar (stage) el hunk actual.                               |
| `<leader>hr`                          | Reiniciar (reset) el hunk actual.                             |
| `<leader>hp`                          | Previsualizar el hunk.                                        |
| `<leader>hb`                          | Ver el blame de la línea actual.                              |
| **Otros**                             |                                                               |
| `<leader>?`                           | Mostrar los atajos de teclado locales del buffer (which-key). |

## 7. Plugins Destacados

| Plugin                                 | Descripción                                                             |
| :------------------------------------- | :---------------------------------------------------------------------- |
| [LazyVim/LazyVim](...)                 | El núcleo de la configuración, proveyendo una base sólida y extensible. |
| [catppuccin/nvim](...)                 | Un relajante tema en tonos pastel para Neovim.                          |
| [hrsh7th/nvim-cmp](...)                | Un motor de autocompletado para LSP, snippets, buffers y rutas.         |
| [windwp/nvim-autopairs](...)           | Cierra automáticamente pares de corchetes, paréntesis, comillas, etc.   |
| [akinsho/bufferline.nvim](...)         | Una línea superior que muestra todos los buffers abiertos.              |
| [norcalli/nvim-colorizer.lua](...)     | Resalta los códigos de color con su color real.                         |
| [github/copilot.vim](...)              | Integración de GitHub Copilot.                                          |
| [stevearc/conform.nvim](...)           | Formateador para dar formato al código al guardar.                      |
| [lewis6991/gitsigns.nvim](...)         | Muestra indicadores de git en la columna de signos.                     |
| [nvim-lualine/lualine.nvim](...)       | Una línea de estado potente y personalizable.                           |
| [williamboman/mason.nvim](...)         | Gestor de paquetes para servidores LSP, linters y formateadores.        |
| [nvim-neo-tree/neo-tree.nvim](...)     | Un explorador de archivos moderno para Neovim.                          |
| [folke/snacks.nvim](...)               | Potencia la UI con animaciones y mejoras visuales.                      |
| [nvim-telescope/telescope.nvim](...)   | Un buscador difuso (fuzzy finder) para todo.                            |
| [akinsho/toggleterm.nvim](...)         | Un gestor de terminales para Neovim.                                    |
| [nvim-treesitter/nvim-treesitter](...) | Proporciona un mejor resaltado de sintaxis y otras funciones.           |
| [folke/which-key.nvim](...)            | Muestra una ventana emergente con los posibles atajos de teclado.       |

## 8. Cómo Personalizar

- **Añadir un nuevo plugin:** Crea un nuevo archivo `.lua` en `lua/plugins/` con la especificación del plugin. Lazy.nvim lo instalará automáticamente al reiniciar.
- **Cambiar el tema de colores:** Edita el archivo `lua/plugins/colorscheme.lua`. Cambia el nombre del tema y ajusta las opciones según sea necesario.
- **Modificar atajos de teclado:** Edita el archivo `lua/config/maps.lua` para añadir o cambiar atajos globales.
- **Ajustar opciones de Neovim:** Modifica `lua/config/settings.lua` para cambiar las opciones base del editor.

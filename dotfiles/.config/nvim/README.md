# Configuración de Neovim

Esta es una configuración personal de Neovim. A continuación se muestra una lista de los plugins utilizados, la estructura de carpetas y cómo administrar los plugins.

## Plugins

| Plugin | Descripción |
| :--- | :--- |
| [hrsh7th/nvim-cmp](https.github.com/hrsh7th/nvim-cmp) | Un motor de autocompletado para Neovim. Proporciona autocompletado para LSP, snippets, buffers y rutas. |
| [windwp/nvim-autopairs](https.github.com/windwp/nvim-autopairs) | Cierra automáticamente pares de corchetes, paréntesis, comillas, etc. |
| [akinsho/bufferline.nvim](https.github.com/akinsho/bufferline.nvim) | Una línea en la parte superior de Neovim que muestra todos los buffers abiertos. |
| [norcalli/nvim-colorizer.lua](https.github.com/norcalli/nvim-colorizer.lua) | Resalta los códigos de color (por ejemplo, `#FFFFFF`, `rgb(255, 255, 255)`) con su color real. |
| [catppuccin/nvim](https.github.com/catppuccin/nvim) | Un relajante tema en tonos pastel para Neovim. |
| [github/copilot.vim](https://github.com/github/copilot.vim) | Integración de GitHub Copilot para Neovim. |
| [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) | Un formateador que se puede configurar para dar formato al código al guardar. |
| [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Muestra indicadores de git en la columna de signos (por ejemplo, líneas agregadas, modificadas, eliminadas). |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Una línea de estado para Neovim. |
| [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) | Un gestor de paquetes para servidores LSP, servidores DAP, linters y formateadores. |
| [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | Un explorador de archivos para Neovim. |
| [folke/snacks.nvim](https://github.com/folke/snacks.nvim) | Potencia la interfaz de usuario de Neovim con animaciones y mejoras visuales. |
| [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Un buscador difuso (fuzzy finder) para Neovim. Se puede usar para buscar archivos, buffers, commits de git, etc. |
| [akinsho/toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Un gestor de terminales para Neovim. |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Proporciona un mejor resaltado de sintaxis y otras funciones basadas en el lenguaje. |
| [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | Muestra una ventana emergente con los posibles atajos de teclado después de presionar una tecla de prefijo. |

## Atajos de Teclado

| Atajo | Descripción |
| :--- | :--- |
| `<C-s>` | Guardar el archivo actual. |
| `<leader>q` | Cerrar Neovim. |
| `jk` | Salir del modo de inserción. |
| `<C-h>` | Moverse a la ventana de la izquierda. |
| `<C-j>` | Moverse a la ventana de abajo. |
| `<C-k>` | Moverse a la ventana de arriba. |
| `<C-l>` | Moverse a la ventana de la derecha. |
| `<leader>o` | Crear una nueva ventana vertical. |
| `<leader>p` | Crear una nueva ventana horizontal. |
| `L` | Ir al siguiente buffer. |
| `H` | Ir al buffer anterior. |
| `<leader>e` | Alternar el explorador de archivos NeoTree. |
| `<leader>r` | Enfocar el explorador de archivos NeoTree. |
| `<leader>ff` | Buscar archivos con Telescope. |
| `<leader>fg` | Buscar en archivos (live grep) con Telescope. |
| `<leader>fb` | Buscar buffers con Telescope. |
| `<leader>fh` | Buscar etiquetas de ayuda con Telescope. |
| `<C-b>` | Desplazarse hacia arriba en la documentación. |
| `<C-f>` | Desplazarse hacia abajo en la documentación. |
| `<C-Space>` | Activar el autocompletado. |
| `<C-e>` | Cancelar el autocompletado. |
| `<CR>` | Confirmar la selección. |
| `<leader>f` | Formatear el archivo o el rango (en modo visual). |
| `<F7>` | Alternar la terminal. |
| `<leader>?` | Mostrar los atajos de teclado locales del buffer. |
| `]c` | Ir al siguiente hunk de git. |
| `[c` | Ir al hunk de git anterior. |
| `<leader>hs` | Guardar el hunk actual. |
| `<leader>hr` | Reiniciar el hunk actual. |
| `<leader>hS` | Guardar el buffer. |
| `<leader>hu` | Deshacer el guardado del hunk. |
| `<leader>hR` | Reiniciar el buffer. |
| `<leader>hp` | Previsualizar el hunk. |
| `<leader>hb` | Ver el blame de la línea actual. |
| `ih` | Seleccionar el hunk actual. |
| `<C-n>` | Navegar hacia abajo en la lista de Telescope. |
| `<C-p>` | Navegar hacia arriba en la lista de Telescope. |
| `<C-q>` | Enviar el elemento seleccionado a la lista de quickfix. |
| `<CR>` | Abrir el elemento seleccionado en Telescope. |
| `<C-v>` | Abrir en una división vertical en Telescope. |
| `<C-t>` | Abrir en una nueva pestaña en Telescope. |
| `l` | Abrir en NeoTree. |
| `h` | Cerrar el nodo en NeoTree. |
| `Y` | Copiar la ruta al portapapeles en NeoTree. |
| `O` | Abrir con la aplicación del sistema en NeoTree. |
| `P` | Alternar la vista previa en NeoTree. |

## Estructura de Carpetas

La configuración se estructura de la siguiente manera:

```
.
├── init.lua
├── lazy-lock.json
├── lazyvim.json
└── lua
    ├── config
    │   ├── lazy.lua
    │   ├── maps.lua
    │   └── settings.lua
    └── plugins
        ├── autocomplete.lua
        ├── autopairs.lua
        ...
```

*   `init.lua`: El punto de entrada principal para la configuración.
*   `lazy-lock.json`: El archivo de bloqueo para el gestor de plugins lazy.nvim.
*   `lazyvim.json`: Archivo de configuración para lazyvim.
*   `lua/config`: Contiene los archivos de configuración principales para Neovim.
    *   `lazy.lua`: La configuración para el gestor de plugins lazy.nvim.
    *   `maps.lua`: Mapeos de teclas globales.
    *   `settings.lua`: Configuraciones globales de Neovim.
*   `lua/plugins`: Contiene la configuración de cada plugin. Cada archivo en este directorio devuelve una tabla con la configuración del plugin.

## Gestión de Plugins

Esta configuración utiliza [lazy.nvim](https://github.com/folke/lazy.nvim) para gestionar los plugins.

### Añadir un Plugin

1.  Crea un nuevo archivo `.lua` en el directorio `lua/plugins` (p. ej., `lua/plugins/nuevo-plugin.lua`).
2.  En el nuevo archivo, añade la configuración del plugin. Por ejemplo:

    ```lua
    return {
      "usuario/repo",
      -- Opcional: especificar una versión
      version = "*",
      -- Opcional: especificar dependencias
      dependencies = { "otro/plugin" },
      -- Opcional: ejecutar una función después de que se cargue el plugin
      config = function()
        -- Tu configuración aquí
      end,
    }
    ```
3.  Reinicia Neovim. lazy.nvim instalará automáticamente el nuevo plugin.

### Eliminar un Plugin

1.  Elimina el archivo de configuración del plugin del directorio `lua/plugins`.
2.  Reinicia Neovim. lazy.nvim desinstalará automáticamente el plugin.
3.  También puedes ejecutar `:Lazy clean` para eliminar cualquier plugin que no se esté utilizando.
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	opts = {
		-- Esta es la clave: el 'position' global para Neotree
		position = "right",
		-- Opcional: para controlar las propiedades de la ventana del árbol
		window = {
			width = 30, -- Ejemplo de ancho
			position = "right", -- Esto puede ayudar a reforzar la posición
		},
		-- Otros ajustes de Neo-tree aquí (ej. sources, renderer, etc.)
	},
}

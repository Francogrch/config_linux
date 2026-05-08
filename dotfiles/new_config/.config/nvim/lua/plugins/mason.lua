return {
	{
		"mason-org/mason.nvim",
		-- Usamos build para asegurar que se instalen los binarios correctamente en Fedora
		build = ":MasonUpdate",
		opts = {
			ui = {
				border = "rounded",
			},
			ensure_installed = {
				"prettierd", -- Formateador para React/Web
				"prettier", -- Formateador fallback
				"stylua", -- Formateador para Lua
				"shfmt", -- Formateador para bash
				"eslint_d", -- Linter para React/Web
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				-- Python & Django
				"pyrefly",
				"ruff",

				-- Web & React
				"vtsls",
				"eslint",
				"biome",
				"html",
				"cssls",
				"emmet_ls",

				-- Config & Infra
				"lua_ls",
				"jsonls",
				"yamlls",
				"dockerls",
				"docker_compose_language_service",
				"bashls",
				"marksman",

				-- Otros
				"jdtls",
				"lemminx",
				"sqlls",
			},
		},
		-- Este bloque previene que LazyVim intente cargar módulos inexistentes
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)
		end,
	},
}

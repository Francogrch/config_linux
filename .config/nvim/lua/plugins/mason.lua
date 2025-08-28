return {
	{
		"williamboman/mason.nvim",
		version = "*",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		version = "1.26.0",
		opts = {
			-- La lista de servidores que quieres que Mason instale automáticamente.
			ensure_installed = {
				"biome",
				"html",
				"cssls",
				"jdtls",
				"pyright",
				"lemminx",
				"emmet_ls",
				"jsonls",
				"lua_ls",
				"marksman",
				"dockerls",
				"docker_compose_language_service",
				"bashls",
				"sqlls",
				"yamlls",
			},
		},
	},
}

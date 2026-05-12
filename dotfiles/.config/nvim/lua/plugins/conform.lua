return {
	"stevearc/conform.nvim",
	opts = {
		-- Formateadores que quieres usar por tipo de archivo
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format" },

			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },

			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
		},
	},
	-- Configuración de los atajos de teclado (keymaps)
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
			end,
			mode = { "n", "v" },
			desc = "Format file or range (in visual mode)",
		},
	},
}

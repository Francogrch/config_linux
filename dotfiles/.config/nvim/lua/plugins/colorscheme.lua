return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		-- the colorscheme should be available when starting Neovim
		-- "folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		opts = function(_, opts)
			opts.transparent_background = true
			opts.float = {
				transparent = true, -- transparencia en ventanas flotantes
				solid = false, -- estilo sólido para ventanas flotantes
			}
			local module = require("catppuccin.groups.integrations.bufferline")
			if module then
				module.get = module.get_theme
			end
			return opts
		end,
		config = function(_, opts)
			require("catppuccin").setup(opts)
			-- load the colorscheme here
			vim.cmd([[colorscheme catppuccin-mocha]])
		end,
	},
}

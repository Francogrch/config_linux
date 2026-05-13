return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					path_display = { "smart" },
					mappings = {
						i = {
							["<C-u>"] = false,
						},
					},
				},
				pickers = {
					find_files = {
						hidden = true,
						search_dirs = { "." },
					},
				},
			})
			telescope.load_extension("fzf")
		end,
	},
}

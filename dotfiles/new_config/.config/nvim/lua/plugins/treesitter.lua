-- :TSInstall <language_to_install>
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"lua",
			"javascript",
			"typescript",
			"html",
			"css",
			"python",
			"angular",
			"java",
		},
		highlight = {
			enable = true,
		},
	},
}

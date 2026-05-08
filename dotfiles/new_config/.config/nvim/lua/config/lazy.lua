-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- Add LazyVim and import its plugins
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		-- Import any extra modules here
		-- Editor plugins
		{ import = "lazyvim.plugins.extras.editor.snacks_explorer" },
		{ import = "lazyvim.plugins.extras.editor.snacks_picker" },

		-- Formatting plugins
		-- { import = "lazyvim.plugins.extras.formatting.biome" },
		-- { import = "lazyvim.plugins.extras.formatting.prettier" },
		--
		-- -- Linting plugins
		-- { import = "lazyvim.plugins.extras.linting.eslint" },
		--
		-- -- Language support plugins
		-- { import = "lazyvim.plugins.extras.lang.json" },
		-- { import = "lazyvim.plugins.extras.lang.markdown" },
		-- { import = "lazyvim.plugins.extras.lang.typescript" },
		-- { import = "lazyvim.plugins.extras.lang.angular" },
		-- { import = "lazyvim.plugins.extras.lang.astro" },
		-- { import = "lazyvim.plugins.extras.lang.go" },
		-- { import = "lazyvim.plugins.extras.lang.nix" },
		-- { import = "lazyvim.plugins.extras.lang.toml" },
		--
		-- -- Coding plugins
		-- { import = "lazyvim.plugins.extras.coding.mini-surround" },
		-- { import = "lazyvim.plugins.extras.editor.mini-diff" },
		--
		-- -- Utility plugins
		{ import = "lazyvim.plugins.extras.util.mini-hipatterns" },

		-- AI plugins
		{ import = "lazyvim.plugins.extras.ai.copilot" },
		{ import = "lazyvim.plugins.extras.ai.copilot-chat" },

		-- Import/override with your plugins
		{ import = "plugins" },
	},

	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
	auto_sync = true,
})

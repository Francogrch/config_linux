vim.g.mapleader = " "

local function map(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- Save
map("n", "<C-s>", "<CMD>update<CR>", { desc = "Save" })

-- Quit
map("n", "<leader>q", "<CMD>q<CR>", { desc = "Quit" })

-- Exit insert mode
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Moverse entre ventanas con Ctrl + H/J/K/L
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- New Windows
map("n", "<leader>o", "<CMD>vsplit<CR>", { desc = "New windows" })
map("n", "<leader>p", "<CMD>split<CR>", { desc = "New windows" })

map("n", "L", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "H", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })

-- PLUGINS
-- NeoTree
map("n", "<leader>e", "<CMD>Neotree toggle<CR>")
map("n", "<leader>r", "<CMD>Neotree focus<CR>")

-- Telescope
local builtin = require("telescope.builtin")
map("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

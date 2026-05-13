vim.g.mapleader = " "

local function map(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true })
end

local function get_visual_selection()
	vim.cmd('noau normal! "vy')
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", {})
	return text
end

-- Borrar palabra hacia atrás (Ctrl + Backspace)
map("i", "<C-BS>", "<C-w>", { desc = "Borrar palabra hacia atrás" })

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

-- Navegación rápida por número
for i = 1, 9 do
	map("n", "<A-" .. i .. ">", "<cmd>BufferLineGoToBuffer " .. i .. "<CR>", { desc = "Buffer " .. i })
end

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

-- Abrir Lazygit con Snacks
map("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

-- Buscar la selección en los nombres de archivos (find_files)
map("v", "<leader>ff", function()
	local text = get_visual_selection()
	require("telescope.builtin").find_files({ default_text = text })
end, { desc = "Telescope find files (selection)" })

-- Buscar el contenido de la selección dentro de los archivos (live_grep)
map("v", "<leader>fg", function()
	local text = get_visual_selection()
	require("telescope.builtin").live_grep({ default_text = text })
end, { desc = "Telescope live grep (selection)" })

-- Generar un mensaje de commit profesional con Copilot Chat
map("n", "<leader>gC", function()
	local chat = require("CopilotChat")
	-- Definimos las reglas estrictas en el prompt
	local prompt =
		[[ Write a short, professional git commit message in English. Use conventional commits. Output only the message, no explanations. ]]

	chat.ask(prompt, {
		selection = require("CopilotChat.select").gitdiff,
	})
end, { desc = "Copilot: Generate Professional Commit" })

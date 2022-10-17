local helpers = require('samer.helpers')

-- Default keymap options
local opts = { noremap = true, silent = true }

--Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Quick escape
helpers.inoremap("jk", "<ESC>", opts)

-- Window switching
helpers.nnoremap("<C-h>", "<C-w>h", opts)
helpers.nnoremap("<C-j>", "<C-w>j", opts)
helpers.nnoremap("<C-k>", "<C-w>k", opts)
helpers.nnoremap("<C-l>", "<C-w>l", opts)

-- Resize with arrows
helpers.nnoremap("<C-Up>", ":resize -2<CR>", opts)
helpers.nnoremap("<C-Down>", ":resize +2<CR>", opts)
helpers.nnoremap("<C-Left>", ":vertical resize -2<CR>", opts)
helpers.nnoremap("<C-Right>", ":vertical resize +2<CR>", opts)

-- Stay in indent mode
helpers.vnoremap("<", "<gv", opts)
helpers.vnoremap(">", ">gv", opts)

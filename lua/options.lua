-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Adjust tab spacing for PHP files
vim.api.nvim_create_autocmd("Filetype", {
  pattern = { "php" },
  command = "setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab"
})

-- Cursorline
vim.o.cursorline = true

-- Global statusline
vim.o.laststatus = 3

vim.o.cmdheight = 0

-- Hide the mode, we are using lualine for this
vim.o.showmode = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Tab settings
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2

-- Don't care for backups and swaps
vim.o.backup = false
vim.o.swapfile = false
vim.o.writebackup = false

vim.o.wrap = false

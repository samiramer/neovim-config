-- Global statusline
vim.o.laststatus = 3

-- change leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- tab and indent settings
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.breakindent = true
vim.o.wrap = false

-- show line numbers
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.signcolumn = 'yes'

-- save undo history
vim.o.undofile = true

-- case insensitive search unless /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- decrease update time
vim.o.updatetime = 250

-- disable backups and swap files
vim.o.backup = false
vim.o.swapfile = false
vim.o.writebackup = false

-- enable mouse mode
vim.o.mouse = 'a'

-- Adjust tab spacing for PHP files
vim.api.nvim_create_autocmd("Filetype", {
  pattern = { "php" },
  command = "setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab"
})


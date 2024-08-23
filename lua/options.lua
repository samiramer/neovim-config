vim.o.laststatus = 3
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.breakindent = true
vim.o.wrap = false
vim.o.autoindent = true
vim.o.smartindent = true

vim.wo.number = true
vim.wo.relativenumber = true
vim.o.signcolumn = "yes"

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.updatetime = 250

vim.o.backup = false
vim.o.swapfile = false
vim.o.writebackup = false

vim.o.mouse = "a"

vim.o.conceallevel = 2

vim.o.showmode = false

vim.o.colorcolumn = "100"

vim.opt.inccommand = "split"

vim.opt.cursorline = true

-- -- Adjust tab spacing for PHP files
-- vim.api.nvim_create_autocmd("Filetype", {
--      pattern = { "php" },
--      command = "setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab",
-- })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
                vim.highlight.on_yank()
        end,
        group = highlight_group,
        pattern = "*",
})

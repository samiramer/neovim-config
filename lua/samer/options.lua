vim.opt.cmdheight = 1
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.cursorline = true
vim.opt.fileencoding = "utf-8"
vim.opt.ignorecase = true
vim.opt.laststatus = 3
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.wrap = false

-- Highlight on yank
local yankGrp = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    command = "silent! lua vim.highlight.on_yank()",
    group = yankGrp,
})

-- Adjust tab spacing for certian file types
vim.api.nvim_create_autocmd("Filetype php,lua", {
    command = "setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab"
})

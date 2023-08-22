-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n' }, '<leader>h', ':nohlsearch<CR>', { silent = true })

-- Quick escape
vim.keymap.set('i', 'jk', '<Esc>', { silent = true })
vim.keymap.set('i', 'kj', '<Esc>', { silent = true })

-- Clipboard copy/paste
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"+Y', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { silent = true })

-- Stay in indent mode
vim.keymap.set({ 'v' }, '<', '<gv', { silent = true })
vim.keymap.set({ 'v' }, '>', '>gv', { silent = true })

-- Window splitting
vim.keymap.set('n', '<leader>=', ":split<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>-', ":vsplit<CR>", { noremap = true, silent = true })

-- Resize with arrows
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Abbreviation to insert a date while in insert mode
vim.cmd('iab <expr> dts strftime("%F")')

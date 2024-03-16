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

vim.o.conceallevel = 2

-- Adjust tab spacing for PHP files
vim.api.nvim_create_autocmd("Filetype", {
  pattern = { "php" },
  command = "setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab"
})

-- Ease of life keymaps
vim.keymap.set("i", "jk", "<Esc>", { silent = true })
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set({ "n" }, "<leader>h", ":nohlsearch<CR>", { silent = true })

-- Clipboard copy/paste
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y", { silent = true, desc = "Clipboard yank" })
vim.keymap.set({ "n", "v" }, "<leader>Y", "\"+Y", { silent = true, desc = "Clipboard line yank" })
vim.keymap.set({ "n", "v" }, "<leader>p", "\"+p", { silent = true, desc = "Clipboard paste after cursor" })
vim.keymap.set({ "n", "v" }, "<leader>P", "\"+P", { silent = true, desc = "Clipboard paste before cursor" })

-- Stay in indent mode
vim.keymap.set({ "v" }, "<", "<gv", { silent = true, desc = "Indent" })
vim.keymap.set({ "v" }, ">", ">gv", { silent = true, desc = "Reduce indent" })

-- Window splitting
vim.keymap.set("n", "<leader>=", ":split<CR>", { noremap = true, silent = true, desc = 'Horizontal split' })
vim.keymap.set("n", "<leader>-", ":vsplit<CR>", { noremap = true, silent = true, desc = 'Vertical split' })

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

-- Lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {}
local plugins = {
  {
    "rebelot/kanagawa.nvim",
    lazy=false,
    priority=1000
  },
  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = '[F]ind [f]iles' } },
      { '<leader>fw', function() require('telescope.builtin').live_grep() end, { desc = '[F]ind [w]ords' } },
      { '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = '[F]ind [b]uffer' } },
      { '<leader>fg', function() require('telescope.builtin').git_files() end, { desc = '[F]ind [G]it file' } },
      { '<leader>fs', function() require('telescope.builtin').grep_string() end, { desc = '[F]ind [s]tring under cursor' } },
    },
-- nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
-- nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
-- nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>}
  },
  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>lD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>lds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>lws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>lr', vim.lsp.buf.rename, '[R]ename')
          map('<leader>lca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}

require("lazy").setup(plugins, opts)

vim.cmd.colorscheme("kanagawa-wave")

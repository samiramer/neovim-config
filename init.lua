-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically
  use 'christoomey/vim-tmux-navigator' -- Easy vim and tmux navigation
  use { "bluz71/vim-nightfly-colors", as = "nightfly" } -- Nightfly colorscheme
  --
  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  use { -- Phpactor
    'phpactor/phpactor',
    ft = { 'php' },
    tag = '*',
    run = 'composer install --no-dev -o'
  }

  -- Display buffers as tabs.
  use({
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
  })

  use { -- File explorer
    'nvim-tree/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons', -- optional, for file icons
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  use {
    'JoosepAlviste/nvim-ts-context-commentstring',
    after = 'nvim-treesitter',
  }

  use { -- Has some useful utilities like commenting
    'echasnovski/mini.nvim',
  }

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- Enables passing args to live_grep
  use 'nvim-telescope/telescope-live-grep-args.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',

      -- Additional json LS schemas
      'b0o/schemastore.nvim',

      -- For external formatting tools (eslint_d, etc)
      'jose-elias-alvarez/null-ls.nvim',
      'jayp0521/mason-null-ls.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip'
    },
  }
  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- Adjust tab spacing for PHP files
vim.api.nvim_create_autocmd("Filetype", {
  pattern = { "php", "lua" },
  command = "setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab"
})

-- Global statusline
vim.o.laststatus = 3

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

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme nightfly]]

-- Tab settings
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2

-- Don't care for backups and swaps
vim.o.backup = false
vim.o.swapfile = false
vim.o.writebackup = false

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- -- Easier window switching - I TURNED THIS OFF BECAUSE I USE vim-tmux-navigator
-- vim.keymap.set('n', '<C-h>', "<C-w>h", {noremap = true, silent = true })
-- vim.keymap.set('n', '<C-j>', "<C-w>j", {noremap = true, silent = true })
-- vim.keymap.set('n', '<C-k>', "<C-w>k", {noremap = true, silent = true })
-- vim.keymap.set('n', '<C-l>', "<C-w>l", {noremap = true, silent = true })

-- Window splitting
vim.keymap.set('n', '<leader>=', ":split<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>-', ":vsplit<CR>", { noremap = true, silent = true })

-- Resize with arrows
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { silent = true })

-- Close shortcuts
vim.keymap.set('n', '<leader>cc', ':q<CR>', { silent = true })
vim.keymap.set('n', '<leader>cq', ':cclose<CR>', { silent = true })
vim.keymap.set('n', '<leader>ct', ':tabclose<CR>', { silent = true })

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

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'nightfly',
    component_separators = '|',
    section_separators = '',
  },
}

-- setup bufferline
require("bufferline").setup {
  options = {
    show_close_icon = false,
    max_name_length = 25,
    offsets = {
      {
        filetype = 'NvimTree',
        text = '  Files',
        -- highlight = 'Normal',
        text_align = 'left',
      },
    },
    custom_areas = {
      left = function()
        return {
          {
            text = '     ',
            fg = vim.api.nvim_get_hl_by_name('NonText', true).foreground,
            bg = vim.api.nvim_get_hl_by_name('Normal', true).background
          },
        }
      end,
    },
  },
  highlights = {
    fill = {
      bg = vim.api.nvim_get_hl_by_name('Normal', true).background,
    },
  }
}

-- Cycle between bufferline tabs
vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>')
vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>')

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelet = { text = '~' },
  },
}

vim.keymap.set('n', '<leader>gj', ':Gitsigns next_hunk<CR>')
vim.keymap.set('n', '<leader>gk', ':Gitsigns prev_hunk<CR>')
vim.keymap.set({ 'v', 'n' }, '<leader>gs', ':Gitsigns stage_hunk<CR>')
vim.keymap.set({ 'v', 'n' }, '<leader>gr', ':Gitsigns undo_stage_hunk<CR>')
vim.keymap.set('n', '<leader>gR', ':Gitsigns reset_buffer<CR>')
vim.keymap.set({ 'v', 'n' }, '<leader>gp', ':Gitsigns preview_hunk<CR>')
vim.keymap.set('n', '<leader>gb', ':Gitsigns blame_line<CR>')
vim.keymap.set('n', '<leader>gq', ':Gitsigns setqflist<CR>')

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

-- [[ Configure `nvim-tree/nvim-tree.lua` ]]
-- See `:help nvim-tree`
require('nvim-tree').setup({
  disable_netrw = true,
  hijack_netrw = true,
  filters = {
    dotfiles = false,
  },
  view = {
    width = 50,
  },
  git = {
    ignore = false,
  },
  renderer = {
    group_empty = true,
    -- icons = {
    --   show = {
    --     folder_arrow = false,
    --   },
    -- },
    indent_markers = {
      enable = true
    }
  },
  update_focused_file = {
    enable = true
  }
})

-- change border color of nvim tree
vim.api.nvim_set_hl(0, 'NvimTreeWinSeparator', {
  fg = vim.api.nvim_get_hl_by_name('Normal', true).background,
  bg = vim.api.nvim_get_hl_by_name('Normal', true).background,
})

-- toggle nvim tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })

-- this closes neovim if the nvim-tree buffer is the last one open
vim.api.nvim_exec(
  [[
    autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
  ]],
  false
)

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'live_grep_args')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[F]ind [B]uffers' })
vim.keymap.set('n', '<leader>fo', require('telescope.builtin').git_status, { desc = '[F]ind [O]pened Git Files' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind [W]ord In Files' })
vim.keymap.set('n', '<leader>fg', require('telescope').extensions.live_grep_args.live_grep_args,
  { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })
vim.keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps, { desc = '[F]ind [K]eymaps' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = 'all',

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

require('mini.pairs').setup({}) -- auto pairs
require('mini.comment').setup { -- commenting
  hooks = {
    pre = function()
      require('ts_context_commentstring.internal').update_commentstring()
    end,
  },
}

-- Phpactor keymaps for my new favorite plugin!!!!
vim.keymap.set('n', '<leader>pm', ':PhpactorContextMenu<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>lk', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>lj', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist)

-- LSP settings.

-- Enable debug mode
vim.lsp.set_log_level("debug")

-- This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local map = function(keys, func, desc, mode)
    if desc then
      desc = 'LSP: ' .. desc
    end

    if not mode then
      mode = 'n'
    end

    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
  end

  map('<leader>lr', vim.lsp.buf.rename, '[L]SP [R]ename')
  map('<leader>la', vim.lsp.buf.code_action, '[L]SP Code [A]ction')

  map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  map('<leader>lD', vim.lsp.buf.type_definition, '[L]SP Type [D]efinition')
  map('<leader>lds', require('telescope.builtin').lsp_document_symbols, '[L]SP [D]ocument [S]ymbols')
  map('<leader>lws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[L]SP [W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  map('K', vim.lsp.buf.hover, 'Hover Documentation')
  map('<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation')
  map('<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation', 'i')


  -- Lesser used LSP functionality
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  map('<leader>lwa', vim.lsp.buf.add_workspace_folder, '[L]SP [W]orkspace [A]dd Folder')
  map('<leader>lwr', vim.lsp.buf.remove_workspace_folder, '[L]SP [W]orkspace [R]emove Folder')
  map('<leader>lwl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[L]SP [W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format({ timeout_ms = 5000 })
    -- vim.lsp.buf.format {
    --   filter = function(client) return client.name ~= "intelephense" end
    -- }
  end, { desc = 'Format current buffer with LSP' })

  map('<leader>lf', ":Format<CR>", '[L]SP [F]ormat current buffer')
end

-- Enable the following language servers
--  Add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  cssls = {},
  tsserver = {},
  -- intelephense = {
  --   format = {
  --     enable = false
  --   }
  -- },
  phpactor = {
    ["language_server.diagnostic_sleep_time"] = 0
  },
  tailwindcss = {},
  jsonls = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
  volar = {
    -- Enable "Take Over Mode" where volar will provide all JS/TS LSP services
    -- This drastically improves the responsiveness of diagnostic updates on change
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  },
  sumneko_lua = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Enable the following external sources for formatting and diagnostics
-- null-ls will be hooked onto the LSP server by mason-null-ls
require('null-ls').setup {
  debug = true,
  ensure_installed = { 'eslint_d', 'prettierd', 'phpcbf', 'phpcsfixer' },
  sources = {
    require('null-ls').builtins.diagnostics.eslint_d.with({
      condition = function(utils)
        return utils.root_has_file({ '.eslintrc.js' })
      end,
    }),
    require('null-ls').builtins.diagnostics.trail_space.with({ disabled_filetypes = { 'NvimTree' } }),
    require('null-ls').builtins.formatting.eslint_d.with({
      condition = function(utils)
        return utils.root_has_file({ '.eslintrc.js' })
      end,
    }),
    -- require('null-ls').builtins.formatting.phpcbf,
    -- require('null-ls').builtins.formatting.phpcsfixer.with({ env = { PHP_CS_FIXER_IGNORE_ENV = 'True' } }),
    require('null-ls').builtins.formatting.prettierd,
  }
}

require('mason-null-ls').setup({ automatic_installation = true })

-- Turn on lsp status information
require('fidget').setup({
  timer = {
    fidget_decay = 250, -- how long to keep around empty fidget, in ms
    task_decay = 250, -- how long to keep around completed task, in ms
  },
})

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-b>'] = cmp.mapping.scroll_docs(-1),
    ['<C-f>'] = cmp.mapping.scroll_docs(1),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-Space>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<Tab>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default mapping.
    ["<S-Tab>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default mapping.
    ['<C-j>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-k>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
}
-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- -- Useful status updates for LSP
      -- 'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',

      -- Additional json LS schemas
      'b0o/schemastore.nvim',

      -- For external formatting tools (eslint_d, etc)
      'jose-elias-alvarez/null-ls.nvim',
      'jayp0521/mason-null-ls.nvim',

      -- Autocompletion support
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',

      "nvim-treesitter/nvim-treesitter"
    },
    config = function()
      -- LSP settings.

      -- Enable debug mode
      -- vim.lsp.set_log_level("debug")

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

        map('<leader>lr', vim.lsp.buf.rename, 'LSP Rename')
        map('<leader>la', vim.lsp.buf.code_action, 'LSP Code Action')

        map('gd', vim.lsp.buf.definition, 'Goto Definition')
        map('gr', require('telescope.builtin').lsp_references, 'Goto References')
        map('gI', vim.lsp.buf.implementation, 'Goto Implementation')

        map('<leader>lD', vim.lsp.buf.type_definition, 'LSP Type Definition')
        map('<leader>lds', require('telescope.builtin').lsp_document_symbols, 'LSP Document Symbols')
        map('<leader>lws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'LSP Workspace Symbols')

        -- See `:help K` for why this keymap
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation')
        map('<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation', 'i')

        -- Lesser used LSP functionality
        map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
        map('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'LSP Workspace Add Folder')
        map('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'LSP Workspace Remove Folder')
        map('<leader>lwl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, 'LSP Workspace List Folders')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format({ timeout_ms = 5000 })
          -- vim.lsp.buf.format {
          --   filter = function(client) return client.name ~= "intelephense" end
          -- }
        end, { desc = 'Format current buffer with LSP' })

        map('<leader>lf', ":Format<CR>", 'LSP Format current buffer')
      end

      -- vim.keymap.set('n', '<leader>lk', ':Lspsaga diagnostic_jump_next<CR>')
      -- vim.keymap.set('n', '<leader>lj', ':Lspsaga diagnostic_jump_prev<CR>')
      -- vim.keymap.set('n', '<leader>le', ':Lspsaga show_line_diagnostics<CR>')
      vim.keymap.set('n', '<leader>lk', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<leader>lj', vim.diagnostic.goto_prev)
      vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float)
      vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist)

      -- Enable the following language servers
      --  Add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. They will be passed to
      --  the `settings` field of the server config. You must look up that documentation yourself.
      local servers = {
        cssls = {},
        tsserver = {},
        intelephense = {
          format = {
            enable = false
          }
        },
        -- tailwindcss = {},
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
        lua_ls = {
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
              return utils.root_has_file({ '.eslintrc.js', '.eslintrc', '.eslintrc.cjs' })
            end,
          }),
          require('null-ls').builtins.diagnostics.trail_space.with({ disabled_filetypes = { 'NvimTree', 'text', 'log' } }),
          require('null-ls').builtins.formatting.eslint_d.with({
            condition = function(utils)
              return utils.root_has_file({ '.eslintrc.js', '.eslintrc', '.eslintrc.cjs' })
            end,
          }),
          require('null-ls').builtins.formatting.phpcbf,
          require('null-ls').builtins.formatting.phpcsfixer.with({
            env = { PHP_CS_FIXER_IGNORE_ENV = 'True' },
            condition = function(utils)
              return utils.root_has_file({ '.php-cs-fixer.php' })
            end,
          }),
          require('null-ls').builtins.formatting.prettierd.with({
            condition = function(utils)
              return utils.root_has_file({ '.prettierrc' })
            end,
          }),
        }
      }

      require('mason-null-ls').setup({ automatic_installation = true })
    end
  }
}

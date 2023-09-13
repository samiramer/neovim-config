return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    version = false,
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-omni',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip'
    },
    config = function()
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
          ['<C-y>'] = cmp.config.disable,   -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
          ['<Tab>'] = cmp.config.disable,   -- Specify `cmp.config.disable` if you want to remove the default mapping.
          ['<S-Tab>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default mapping.
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
          { name = 'omni' }
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
    end
  }
}

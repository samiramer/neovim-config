return {
  -- colorscheme
  -- {
  --   'projekt0n/github-nvim-theme',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- Set colorscheme
  --     vim.o.termguicolors = true
  --     vim.cmd.colorscheme('github_dark_high_contrast')
  --   end
  -- },

  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    opts = {
      contrast = 'hard',
      bold = false,
      invert_selection = true,
    },
    config = function(_, opts)
      vim.o.termguicolors = true
      require('gruvbox').setup(opts)
      vim.cmd.colorscheme('gruvbox')
    end
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    'bluz71/vim-nightfly-colors',
    name = 'nightfly',
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.o.termguicolors = true
      -- vim.cmd.colorscheme('nightfly')
    end
  },

  -- file explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>e', ':NvimTreeFindFileToggle<cr>', { desc = 'Toggle Nvim Tree' } },
    },
    opts = {
      disable_netrw = true,
      hijack_netrw = true,
      filters = {
        dotfiles = false,
      },
      view = {
        width = 50,
        float = {
          enable = true,
          quit_on_focus_loss = true,
          open_win_config = {
            relative = "editor",
            border = "rounded",
            width = 60,
            height = 30,
            row = 1,
            col = 1,
          },
        },
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
    },
    config = function(_, opts)
      require('nvim-tree').setup(opts)

      vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
          local invalid_win = {}
          local wins = vim.api.nvim_list_wins()
          for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if bufname:match("NvimTree_") ~= nil then
              table.insert(invalid_win, w)
            end
          end
          if #invalid_win == #wins - 1 then
            -- Should quit, so we close all invalid windows.
            for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
          end
        end
      })
    end
  },

  -- nicer buffer delet
  {
    'famiu/bufdelete.nvim',
    keys = {
      { '<leader>cc', '<cmd>Bdelete<cr>', {} },
    }
  },

  { 'christoomey/vim-tmux-navigator' }, -- Easy vim and tmux navigation

  -- utility for commenting
  {
    'echasnovski/mini.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function()
      require('mini.pairs').setup({}) -- auto pairs
      require('mini.comment').setup { -- commenting
        hooks = {
          pre = function()
            require('ts_context_commentstring.internal').update_commentstring({})
          end,
        }
      }
    end
  },

  -- buffer display
  {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
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
        highlights = {
          fill = {
            bg = vim.api.nvim_get_hl_by_name('Normal', true).background,
          },
        }
      },
    },
    keys = {
      { '<Tab>',   '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
      { '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Previous buffer' },
    },
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = .75 -- width will be 85% of the editor width
      }
    },
    keys = { { '<leader>zz', '<cmd>ZenMode<cr>', desc = 'Toggle ZenMode' }, }
  },
}

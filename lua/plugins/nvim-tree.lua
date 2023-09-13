return {
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
          enable = false,
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
}

return {
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
}

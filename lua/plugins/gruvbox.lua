return {
  -- colorscheme
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    opts = {
      contrast = 'medium',
      bold = false,
      invert_selection = true,
    },
    config = function(_, opts)
      vim.o.termguicolors = true
      vim.o.background = 'dark'
      require('gruvbox').setup(opts)
      vim.cmd.colorscheme('gruvbox')
    end
  },
}

return {
  -- colorscheme
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
}

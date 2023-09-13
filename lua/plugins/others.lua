return {
  -- nicer buffer delete
  {
    'famiu/bufdelete.nvim',
    keys = {
      { '<leader>cc', '<cmd>Bdelete<cr>', {} },
    }
  },

  -- easy vim and tmux naviation
  { 'christoomey/vim-tmux-navigator' },
}

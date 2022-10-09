vim.cmd [[
  set background=dark

  augroup user_colors
    autocmd!
    autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
  augroup END

  " Set contrast.
  " This configuration option should be placed before `colorscheme gruvbox-material`.
  " Available values: 'hard', 'medium'(default), 'soft'
  " let g:gruvbox_material_background = 'hard'
  " let g:gruvbox_material_foreground = 'original'
  " For better performance
  " let g:gruvbox_material_better_performance = 1

  " colorscheme gruvbox-material
  " colorscheme terafox
  " colorscheme nightfox
  " colorscheme nord
  " colorscheme carbon
  " colorscheme gruvbox
  colorscheme catppuccin

]]

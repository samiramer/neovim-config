vim.cmd [[
  set background=dark

  let g:material_style = "default"
  let g:nord_contrast = v:true
  let g:nord_borders = v:false
  let g:nord_disable_background = v:false
  let g:nord_italic = v:false
  let g:nord_uniform_diff_background = v:true

  " Set contrast.
  " This configuration option should be placed before `colorscheme gruvbox-material`.
  " Available values: 'hard', 'medium'(default), 'soft'
  let g:gruvbox_material_background = 'hard'
  " For better performance
  let g:gruvbox_material_better_performance = 1

  colorscheme gruvbox-material
  " colorscheme terafox
  " colorscheme nord

]]

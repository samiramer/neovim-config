return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        'bash',
        'c',
        'html',
        'javascript',
        'json',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'php',
        'tsx',
        'twig',
        'tsx',
        'typescript',
        'vim',
        'vue',
        'vimdoc',
        'yaml'
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end
  }
}

return {
  {
    "mason-org/mason.nvim",
    lazy = true,
    cmd = "Mason",
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
		event = { "BufReadPre", "BufNewFile" },
    cmd = "Mason",
    dependencies = {
        "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "clangd",
        "clang-format",
        "css-lsp",
        "emmet-language-server",
        "eslint-lsp",
        "eslint_d",
        "html-lsp",
        "intelephense",
        "lua-language-server",
        "phpcs",
        "php-cs-fixer",
        "php-debug-adapter",
        "prettier",
        "stylelint-lsp",
        "stylua",
        "tailwindcss-language-server",
        "typescript-language-server",
        "vue-language-server",
      },
      run_on_start = true,
    },
  }
}

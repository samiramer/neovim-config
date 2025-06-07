return {
  {
    'saghen/blink.cmp',
    event = { "BufReadPre", "BufNewFile" },
    lazy = true,
    version = '1.*',
    opts = {
      completion = { documentation = { auto_show = true } },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      sources = {
        default = { 'lsp', 'buffer', 'snippets', 'path', 'cmdline' },
      },
    }
  }
}

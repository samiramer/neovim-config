local M = {}

M.setup_clients = function()

  local status_lsp, lspconfig = pcall(require, "lspconfig")
  if not status_lsp then return end

  local handlers = require "samer.lsp.handlers"

  local opts = {
    on_attach = handlers.on_attach,
    capabilities = handlers.capabilities,
  }

  local sumneko_opts = require "samer.lsp.clients.sumneko_lua"
  lspconfig.sumneko_lua.setup(vim.tbl_deep_extend("force", sumneko_opts, opts))

  local intelephense_opts = require "samer.lsp.clients.intelephense"
  lspconfig.intelephense.setup(vim.tbl_deep_extend("force", intelephense_opts, opts))

  lspconfig.jsonls.setup(opts)
  lspconfig.tsserver.setup(opts)
  lspconfig.cssls.setup(opts)
  lspconfig.volar.setup(opts)

end

M.setup_formatters = function()

  local null_ls_status_ok, null_ls = pcall(require, "null-ls")
  if not null_ls_status_ok then
    return
  end

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting

  null_ls.setup({
    debug = true,
    sources = {
      formatting.eslint_d,
      formatting.phpcbf,
      formatting.phpcsfixer,
      formatting.prettier
    }
  })
end

return M

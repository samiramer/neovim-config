local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

lsp_installer.setup {}

local status_lspconfig_ok, lsp_config = pcall(require, "lspconfig")
if not status_lspconfig_ok then
	return
end

local opts = {
  on_attach = require("lsp.handlers").on_attach,
  capabilities = require("lsp.handlers").capabilities,
}

local jsonls_opts = require("lsp.settings.jsonls")
lsp_config.jsonls.setup(vim.tbl_deep_extend("force", jsonls_opts, opts))

local sumneko_opts = require("lsp.settings.sumneko_lua")
lsp_config.sumneko_lua.setup(vim.tbl_deep_extend("force", sumneko_opts, opts))

local intelephense_opts = require("lsp.settings.intelephense")
lsp_config.intelephense.setup(vim.tbl_deep_extend("force", intelephense_opts, opts))

lsp_config.tsserver.setup(opts)
lsp_config.cssls.setup(opts)
lsp_config.volar.setup(opts)

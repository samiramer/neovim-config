local status_mason, mason = pcall(require, "mason")

if (status_mason) then
  mason.setup()
end

--
-- setup the lsp
--
local status_lsp, _ = pcall(require, "lspconfig")
local status_mlsp, mlsp = pcall(require, "mason-lspconfig")

if (status_mason and status_lsp and status_mlsp) then
  mlsp.setup({
    automatic_installation = true
  })

  require('samer.lsp').setup_clients()
end

local status_null, _ = pcall(require, "null-ls")
local status_mnull, mnull = pcall(require, "mason-null-ls")

print(status_mason)
if (status_mason and status_null and status_mnull) then
  mnull.setup({
    ensure_installed = {
      'eslint_d',
      'phpcbf',
      'phpcsfixer',
      'prettier',
    }
  })

  require('samer.lsp').setup_formatters()
end

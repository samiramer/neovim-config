return {
	-- colorscheme
	{
		"bluz71/vim-nightfly-colors",
		name = "nightfly",
		priority = 1000,
		config = function(_, opts)
			vim.o.termguicolors = true
			vim.o.background = "dark"
			vim.g.nightflyCursorColor = true
			vim.g.nightflyNormalFloat = true
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "single",
			})
			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
				border = "single",
			})
			vim.diagnostic.config({ float = { border = "single" } })
			-- Lua initialization file
			vim.g.nightflyVirtualTextColor = true
			-- Lua initialization file
			vim.g.nightflyVirtualTextColor = true
			vim.cmd.colorscheme("nightfly")
		end,
	},
}

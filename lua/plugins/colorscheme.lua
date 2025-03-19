return {
	{
		"bluz71/vim-nightfly-colors",
		name = "nightfly",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.nightflyNormalFloat = true
			vim.g.nightflyCursorColor = true
			vim.g.nightflyVirtualTextColor = true
			vim.g.nightflyWinSeparator = 2
			vim.opt.fillchars = {
				horiz = "━",
				horizup = "┻",
				horizdown = "┳",
				vert = "┃",
				vertleft = "┫",
				vertright = "┣",
				verthoriz = "╋",
			}
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "single",
			})
			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
				border = "single",
			})
			vim.diagnostic.config({ float = { border = "single" } })

			require("nightfly")
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("gruvbox").setup({
				contrast = "hard",
				bold = false,
			})
		end,
	},
	{ "rebelot/kanagawa.nvim", priority = 1000, lazy = false },
	{ "EdenEast/nightfox.nvim", priority = 1000, lazy = false },
}

return {
	{
		"karb94/neoscroll.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		config = function()
			-- require("neoscroll").setup({})
		end,
	},

	{
		"famiu/bufdelete.nvim",
		keys = {
			{ "<leader>cc", "<cmd>Bdelete<cr>", desc = "Close buffer" },
		},
	},

	{ "christoomey/vim-tmux-navigator", lazy = false },

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},

	{
		"tpope/vim-commentary",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	},

}

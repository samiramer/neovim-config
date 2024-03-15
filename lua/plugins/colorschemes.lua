return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			require("tokyonight").setup()
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("kanagawa").setup()
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
				invert_selection = false,
			})
		end,
	},
}

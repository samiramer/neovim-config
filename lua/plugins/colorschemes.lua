return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require('kanagawa').setup()
    end
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

return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	version = false,
	build = ":TSUpdate",
  opts = {
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"html",
				"javascript",
				"json",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"php",
				"tsx",
				"twig",
				"tsx",
				"typescript",
				"vim",
				"vue",
				"vimdoc",
				"yaml",
			},
  },
	config = function(opts)
		require("nvim-treesitter.configs").setup(opts)
	end,

	-- auto tagging
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
	},
}

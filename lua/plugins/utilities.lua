return {
	-- code commenting
	{
		"tpope/vim-commentary",
		event = { "BufReadPre", "BufNewFile" },
	},

	-- vim keybings to jump between tmux and nvim
	{ "christoomey/vim-tmux-navigator", lazy = false },

	-- autodetect shiftwidth and tabstop
	{
		"tpope/vim-sleuth",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.g.sleuth_twig_heuristics = 0
		end,
	},
}

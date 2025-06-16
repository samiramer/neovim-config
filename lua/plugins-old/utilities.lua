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

	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {"NvimTree"},
					},
					always_divide_middle = true,
					globalstatus = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { { "filename", path = 3 }, },
					lualine_c = {},
					lualine_x = { "diff", "diagnostics", "branch", "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = { "filename" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
}

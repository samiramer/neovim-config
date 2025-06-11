return {
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
						statusline = { "NvimTree" },
					},
					always_divide_middle = true,
					globalstatus = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { { "filename", path = 3 } },
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
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>" },
			{ "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>" },
		},
		config = function()
			require("nvim-tree").setup({
				disable_netrw = true,
				hijack_netrw = true,
				filters = {
					dotfiles = false,
				},
				git = {
					ignore = false,
				},
				renderer = {
					group_empty = true,
					indent_markers = {
						enable = true,
					},
					icons = {
						show = {
							folder_arrow = true,
							hidden = true,
						},
					},
				},
				view = {
					side = "right",
					width = 60,
				},
			})

			vim.api.nvim_create_autocmd("QuitPre", {
				callback = function()
					local invalid_win = {}
					local wins = vim.api.nvim_list_wins()
					for _, w in ipairs(wins) do
						local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
						if bufname:match("NvimTree_") ~= nil then
							table.insert(invalid_win, w)
						end
					end
					if #invalid_win == #wins - 1 then
						-- Should quit, so we close all invalid windows.
						for _, w in ipairs(invalid_win) do
							vim.api.nvim_win_close(w, true)
						end
					end
				end,
			})
		end,
	},
}

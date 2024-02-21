return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-live-grep-args.nvim",
		},
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files({ hidden = true })
				end,
				desc = "Find files",
			},
			{
				"<leader>fw",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Live grep",
			},
			{
				"<leader>fc",
				function()
					require("telescope.builtin").grep_string()
				end,
				desc = "Search word",
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Find buffers",
			},
			{
				"<leader>fd",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "Find diagnostics",
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").git_status()
				end,
				desc = "Find modified files",
			},
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				pickers = {
					live_grep = {
						file_ignore_patterns = { "node_modules", ".git", "vendor" },
						additional_args = function(_)
							return { "--hidden" }
						end,
					},
					grep_string = {
						file_ignore_patterns = { "node_modules", ".git", "vendor" },
						additional_args = function(_)
							return { "--hidden" }
						end,
					},
					find_files = {
						file_ignore_patterns = { "node_modules", ".git", "vendor" },
						hidden = true,
					},
				},
				path_display = { "truncate " },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
				defaults = {
					layout_config = {
						horizontal = {
							height = 0.95,
							preview_cutoff = 60,
							width = 0.95,
						},
					},
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("live_grep_args")
		end,
	},
}

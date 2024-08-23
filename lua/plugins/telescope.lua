return {
	{ -- telescope
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				version = "^1.0.0",
			},
		},
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files({ hidden = true })
				end,
				{ desc = "[F]ind [f]iles" },
			},
			{
				"<leader>fw",
				function()
					require("telescope").extensions.live_grep_args.live_grep_args({ hidden = true })
				end,
				{ desc = "[F]ind [w]ords" },
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
				{ desc = "[F]ind [b]uffer" },
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").git_files()
				end,
				{ desc = "[F]ind [G]it file" },
			},
			{
				"<leader>fs",
				function()
					require("telescope.builtin").grep_string({ hidden = true })
				end,
				{ desc = "[F]ind [s]tring under cursor" },
			},
			{
				"<leader>fc",
				function()
					require("telescope.builtin").colorscheme({ enable_preview = true })
				end,
				{ desc = "[F]ind [c]olorscheme" },
			},
		},
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "vertical",
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension, "live_grep_args")
		end,
	},
}

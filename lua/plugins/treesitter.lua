return {
	{ -- treesitter (syntax highlighting and other nice features)
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		lazy = true,
		opts = {
			ensure_installed = {
				"bash",
				"blade",
				"c",
				"html",
				"javascript",
				"json",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"php",
				"tsx",
				"twig",
				"typescript",
				"vim",
				"vue",
				"vimdoc",
				"yaml",
			},
			indent = { enable = true },
			auto_install = true,
			highlight = {
				enable = true,
				disable = function(_, buf)
					local max_filesize = 1000 * 1024 -- 1 MB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end

					return false
				end,
			},
		},
		config = function(_, opts)
			vim.filetype.add({
				pattern = {
					["*.blade.php"] = "blade",
				},
			})

			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{ -- context based commenting support
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = { "BufReadPre", "BufNewFile" },
	},
}

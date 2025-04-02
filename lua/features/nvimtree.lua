return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
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
				-- 	indent_markers = {
				-- 		enable = true,
				-- 	},
				-- },
				-- update_focused_file = {
				-- 	enable = true,
				-- },
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

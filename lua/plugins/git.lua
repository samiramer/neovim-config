return {
	{ "tpope/vim-fugitive", cmd = "Git" }, -- super useful Git plugin

	{                                     -- adds git signs to the gutter and other useful git features
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			signcolumn = true,
			on_attach = function()
				local gs = package.loaded.gitsigns
				vim.keymap.set("n", "<leader>gj", gs.next_hunk, { desc = "Go to next hunk" })
				vim.keymap.set("n", "<leader>gk", gs.prev_hunk, { desc = "Go to previous hunk" })
				vim.keymap.set({ "n", "v" }, "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
				vim.keymap.set({ "n", "v" }, "<leader>gh", gs.reset_hunk, { desc = "Reset hunk" })
				vim.keymap.set("n", "<leader>gb", gs.stage_buffer, { desc = "Stage buffer" })
				vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage buffer" })
				vim.keymap.set("n", "<leader>gr", gs.reset_buffer, { desc = "Reset buffer" })
				vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
				vim.keymap.set("n", "<leader>gl", function()
					gs.blame_line({ full = true })
				end, { desc = "Git blame" })
				vim.keymap.set("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
				vim.keymap.set("n", "<leader>gD", function()
					gs.diffthis("~")
				end, { desc = "Diff this ~" })
			end,
		},
	},
}

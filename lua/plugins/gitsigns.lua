return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(_)
        local gs = package.loaded.gitsigns
        vim.keymap.set("n", "<leader>gj", gs.next_hunk)
        vim.keymap.set("n", "<leader>gk", gs.prev_hunk)
        vim.keymap.set({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>")
        vim.keymap.set({ "n", "v" }, "<leader>gh", ":Gitsigns reset_hunk<CR>")
        vim.keymap.set("n", "<leader>ghS", gs.stage_buffer)
        vim.keymap.set("n", "<leader>ghu", gs.undo_stage_hunk)
        vim.keymap.set("n", "<leader>gr", gs.reset_buffer)
        vim.keymap.set("n", "<leader>gp", gs.preview_hunk)
        vim.keymap.set("n", "<leader>gl", function() gs.blame_line({ full = true }) end)
        vim.keymap.set("n", "<leader>gd", gs.diffthis)
        vim.keymap.set("n", "<leader>gD", function() gs.diffthis("~") end)
        vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    },
  }
}

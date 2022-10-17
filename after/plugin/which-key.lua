local status_ok, wk = pcall(require, "which-key")
if not status_ok then return end

wk.setup()

wk.register({

  ["-"] = { ":split<cr>", "Split Horizontally" },
  ["="] = { ":vsplit<cr>", "Split Vertically" },

  c = { ":bdelete!<cr>", "Close current buffer" },
  e = { ":NvimTreeToggle<cr>", "Open Explorer" },

  f = {
    name = "find",
    b = { "<cmd>Telescope buffers<cr>", "Open buffers" },
    g = { "<cmd>Telescope live_grep<cr>", "Find in files" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    w = { "<cmd>Telescope grep_string<cr>", "Find word in files" },
  },

  h = { ":nohlsearch<cr>", "Toggle highlight search" },
}, { prefix = "<leader>" })

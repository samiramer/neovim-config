local status_ok, wk = pcall(require, "which-key")
if not status_ok then return end

wk.setup()

wk.register({

  ["-"] = { ":split<cr>", "Split Horizontally" },
  ["="] = { ":vsplit<cr>", "Split Vertically" },

  c = {
    name = "Close",
    c = { ":bdelete!<cr>", "Close buffer" },
    l = { ":lclose<cr>", "Close list" },
    q = { ":cclose<cr>", "Close quickfix list" },
    t = { ":tabclose<cr>", "Close current tab" },
  },

  e = { ":NvimTreeToggle<cr>", "Open Explorer" },

  f = {
    name = "Find",
    b = { "<cmd>Telescope buffers<cr>", "Open buffers" },
    g = { "<cmd>Telescope live_grep<cr>", "Find in files" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    w = { "<cmd>Telescope grep_string<cr>", "Find word in files" },
  },

  g = {
    name = "Git",
    g = { "<cmd>lua require('neogit').open()<cr>", "Neogit" },
    j = { "<cmd>lua require('gitsigns').next_hunk()<cr>", "Next Hunk" },
    k = { "<cmd>lua require('gitsigns').prev_hunk()<cr>", "Prev Hunk" },
    l = { "<cmd>lua require('gitsigns').toggle_current_line_blame()<cr>", "Blame" },
    p = { "<cmd>lua require('gitsigns').preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require('gitsigns').reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require('gitsigns').reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require('gitsigns').stage_hunk()<cr>", "Stage Hunk" },
    u = {
      "<cmd>lua require('gitsigns').undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    d = {
      "<cmd>lua require('gitsigns').diffthis()<cr>",
      "Diff",
    },
    D = {
      "<cmd>:DiffviewOpen<cr>",
      "Diff",
    },
    h = { "<cmd>DiffviewFileHistory %<cr>", "Git file history" },
    H = { "<cmd>DiffviewFileHistory<cr>", "Git branch file history" },
  },

  h = { ":nohlsearch<cr>", "Toggle highlight search" },

  l = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    d = {
      "<cmd>Telescope lsp_document_diagnostics<cr>",
      "Document Diagnostics",
    },
    f = { "<cmd>lua vim.lsp.buf.format({ async = false })<cr>", "Format" },
    w = {
      "<cmd>Telescope lsp_workspace_diagnostics<cr>",
      "Workspace Diagnostics",
    },
    i = { "<cmd>LspInfo<cr>", "Info" },
    I = { "<cmd>Mason<cr>", "Mason" },
    j = {
      "<cmd>lua vim.diagnostic.goto_next()<CR>",
      "Next Diagnostic",
    },
    k = {
      "<cmd>lua vim.diagnostic.goto_prev()<cr>",
      "Prev Diagnostic",
    },
    q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols theme=ivy<cr>",
      "Workspace Symbols",
    },
  },

}, { prefix = "<leader>" })

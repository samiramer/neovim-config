vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/rebelot/kanagawa.nvim",
	"https://github.com/folke/snacks.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.7.0" },
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

vim.cmd("colorscheme kanagawa")

require("nvim-treesitter").setup()
require("gitsigns").setup()
require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"eslint-lsp",
		"prettier",
		"lua_ls",
		"stylua",
		"intelephense",
		"php-cs-fixer",
		"typescript-language-server",
		"vue-language-server",
	},
})

require("mason-lspconfig").setup()

local util = require("conform.util")
require("conform").setup({
	log_level = vim.log.levels.DEBUG,
	lsp_format = "last",
	formatters_by_ft = {
		c = { "clang-format" },
		lua = { "stylua" },
		php = { "php_cs_fixer", "pint" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		vue = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		markdown = { "prettier" },
		python = { "black" },
	},
	formatters = {
		["pint"] = {
			cwd = util.root_file({ "pint.json" }),
			require_cwd = true,
		},
		["php_cs_fixer"] = {
			env = { PHP_CS_FIXER_IGNORE_ENV = "true" },
			cwd = util.root_file({ ".php-cs-fixer.php" }),
			require_cwd = true,
		},
	},
})

require("blink.cmp").setup({
	sources = { default = { "lsp", "buffer", "snippets", "path", "cmdline" } },
	completion = { documentation = { auto_show = true, auto_show_delay_ms = 100 } },
	signature = { enabled = true },
})

require("snacks").setup({
	picker = { sources = { explorer = { layout = { layout = { position = "right" } } } } },
	layout = { preset = "dropdown" },
	layouts = {
		default = { layout = { width = 0.95, height = 0.9 } },
		dropdown = { layout = { width = 0.95, height = 0.9 } },
	},
})

-- options
vim.o.laststatus = 3
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.breakindent = true
vim.o.wrap = false
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.signcolumn = "yes"
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.backup = false
vim.o.swapfile = false
vim.o.writebackup = false
vim.o.mouse = "a"
vim.o.conceallevel = 2
vim.o.showmode = false
vim.o.colorcolumn = "80"
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.winborder = "single"

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- general keymaps
vim.keymap.set("i", "jk", "<Esc>", { silent = true })
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set({ "n" }, "<leader>h", ":nohlsearch<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { silent = true, desc = "Clipboard yank" })
vim.keymap.set({ "n", "v" }, "<leader>Y", '"+Y', { silent = true, desc = "Clipboard line yank" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { silent = true, desc = "Clipboard paste after cursor" })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { silent = true, desc = "Clipboard paste before cursor" })
vim.keymap.set({ "v" }, "<", "<gv", { silent = true, desc = "Indent" })
vim.keymap.set({ "v" }, ">", ">gv", { silent = true, desc = "Reduce indent" })
vim.keymap.set("n", "<leader>=", ":split<CR>", { noremap = true, silent = true, desc = "Horizontal split" })
vim.keymap.set("n", "<leader>-", ":vsplit<CR>", { noremap = true, silent = true, desc = "Vertical split" })

vim.keymap.set("n", "<leader>ff", function()
	require("snacks").picker.files({ hidden = true })
end)

vim.keymap.set("n", "<leader>fF", function()
	require("snacks").picker.files({ hidden = true, ignored = true })
end)

vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ timeout = 5000 })
end)

vim.keymap.set("n", "<leader>e", require("snacks").picker.explorer)
vim.keymap.set("n", "<leader>fC", require("snacks").picker.colorschemes)
vim.keymap.set("n", "<leader>fb", require("snacks").picker.buffers)
vim.keymap.set("n", "<leader>fr", require("snacks").picker.recent)
vim.keymap.set("n", "<leader>fw", require("snacks").picker.grep)
vim.keymap.set("n", "<leader>fc", require("snacks").picker.grep_word)
vim.keymap.set("n", "<leader>fn", require("snacks").picker.notifications)
vim.keymap.set("n", "<leader>fg", require("snacks").picker.git_files)
vim.keymap.set("n", "<leader>fq", require("snacks").picker.qflist)
vim.keymap.set("n", "<leader>gl", require("snacks").git.blame_line)
vim.keymap.set("n", "<leader>gL", require("snacks").picker.git_log)
vim.keymap.set("n", "<leader>gd", require("snacks").picker.git_diff)
vim.keymap.set("n", "<leader>gb", require("snacks").picker.git_branches)
vim.keymap.set("n", "<leader>gw", require("snacks").picker.git_grep)
vim.keymap.set("n", "<leader>gs", require("snacks").picker.git_status)
vim.keymap.set("n", "<leader>bd", require("snacks").bufdelete.delete)
vim.keymap.set("n", "<leader>bD", require("snacks").bufdelete.all)

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(_)
		vim.keymap.set("n", "gd", require("snacks").picker.lsp_definitions)
		vim.keymap.set("n", "gr", require("snacks").picker.lsp_references)
		vim.keymap.set("n", "gI", require("snacks").picker.lsp_implementations)
		vim.keymap.set("n", "<leader>lD", require("snacks").picker.lsp_type_definitions)
		vim.keymap.set("n", "<leader>lds", require("snacks").picker.lsp_symbols)
		vim.keymap.set("n", "<leader>lde", require("snacks").picker.diagnostics_buffer)
		vim.keymap.set("n", "<leader>lwe", require("snacks").picker.diagnostics)
		vim.keymap.set("n", "<leader>lws", require("snacks").picker.lsp_workspace_symbols)
		vim.keymap.set("n", "<leader>lj", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end)
		vim.keymap.set("n", "<leader>lk", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end)
		vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float)
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename)
		vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action)
		vim.keymap.set("n", "K", vim.lsp.buf.hover)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
	end,
})

-- Simple LSP progress - https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(ev)
		vim.notify(vim.lsp.status(), vim.log.levels.INFO, { id = "lsp_progress", title = "LSP Progress" })
	end,
})

-- auto load treesitter parser
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local blacklist = vim.regex([[^snacks_\|^blink]])

		local ft = vim.bo[args.buf].filetype
    if blacklist:match_str(ft) then return end

		local lang = vim.treesitter.language.get_lang(ft) or ft
		if blacklist:match_str(lang) then return end

		-- install parser if available
		local ok = pcall(vim.treesitter.language.inspect, lang)
		if not ok then
			require("nvim-treesitter").install({ lang })
		end

    -- start treesitter for buffer
    local start_ok, err = pcall(vim.treesitter.start)
    if not start_ok then
      vim.notify("Treesitter failed: " .. err, vim.log.levels.DEBUG)
    end
	end,
})

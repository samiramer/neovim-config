vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/folke/snacks.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.7.0" },
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/theHamsta/nvim-dap-virtual-text",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/rebelot/kanagawa.nvim",
})

vim.o.background = "dark"
-- vim.o.background = "light"
vim.cmd("colorscheme kanagawa")
-- vim.cmd("colorscheme retrobox")
-- vim.cmd("colorscheme lunaperche")

require("mini.icons").setup()
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
		"tailwindcss-language-server",
		"typescript-language-server",
		"vue-language-server",
		"php-debug-adapter",
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

-- treesitter setup
local TS = require("nvim-treesitter")
TS.setup()

local ts_installed = TS.get_installed("parsers")
local ts_required = {
	"lua",
	"php",
	"twig",
	"vue",
	"tsx",
	"javascript",
	"python",
	"json",
	"toml",
}

local ts_install = vim.tbl_filter(function(lang)
	return not vim.tbl_contains(ts_installed, lang)
end, ts_required)

for _, filetype in ipairs(ts_install) do
	TS.install(filetype)
end

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
vim.opt.clipboard = "unnamedplus"

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

-- Start treesitter
vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match)

		if lang == nil then
			return
		end

		vim.treesitter.language.add(lang)
		if vim.treesitter.query.get(lang, "highlights") then
			vim.treesitter.start()
		end
		if vim.treesitter.query.get(lang, "indents") then
			vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
		end
	end,
})

local dap = require("dap")
dap.adapters.php = {
	type = "executable",
	command = "php-debug-adapter",
}

dap.configurations.php = {
	{
		type = "php",
		request = "launch",
		name = "#PHP 84: Listen for Xdebug",
		hostname = "localhost",
		port = 9004,
	},
	{
		type = "php",
		request = "launch",
		name = "DDEV PHP: Listen for Xdebug",
		hostname = "localhost",
		port = 9003,
		pathMappings = {
			["/var/www/html"] = "${workspaceFolder}",
		},
	},
}

local dapui = require("dapui")
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close({})
end

vim.keymap.set({ "n" }, "<leader>du", require("dapui").toggle)
vim.keymap.set({ "n" }, "<leader>de", require("dapui").eval)
vim.keymap.set({ "n" }, "<leader>db", require("dap").toggle_breakpoint)
vim.keymap.set({ "n" }, "<leader>dc", require("dap").continue)
vim.keymap.set({ "n" }, "<leader>dC", require("dap").clear_breakpoints)
vim.keymap.set({ "n" }, "<leader>do", require("dap").step_over)
vim.keymap.set({ "n" }, "<leader>dO", require("dap").step_out)
vim.keymap.set({ "n" }, "<leader>di", require("dap").step_into)
vim.keymap.set({ "n" }, "<leader>dt", require("dap").terminate)
vim.keymap.set({ "n" }, "<leader>dR", require("dap").restart)
vim.keymap.set({ "n" }, "<leader>dR", require("dap.repl").toggle)
vim.keymap.set({ "n" }, "<leader>dh", require("dap.ui.widgets").hover)
vim.keymap.set({ "n" }, "<leader>da", function()
	require("dap").set_exception_breakpoints({ "Warning", "Error", "Exception" })
end)
vim.keymap.set({ "n" }, "<leader>dA", function()
	require("dap").set_exception_breakpoints({})
end)

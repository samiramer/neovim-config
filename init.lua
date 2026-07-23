vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/projekt0n/github-nvim-theme",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/mfussenegger/nvim-lint",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
})

vim.o.laststatus = 3
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.softtabstop = 2
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

require("mini.icons").setup({ style = "ascii" })

require("github-theme").setup({
	palettes = {
		github_dark_dimmed = {
			fg = { default = "#f0f6fc" },
			canvas = { default = "#202830" },
		},
	},
})

require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "<leader>gj", function()
			if vim.wo.diff then
				vim.cmd.normal({ "<leader>gj", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "<leader>gk", function()
			if vim.wo.diff then
				vim.cmd.normal({ "<leader>gk", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		-- Actions
		map("n", "<leader>gs", gitsigns.stage_hunk)
		map("n", "<leader>gh", gitsigns.reset_hunk)

		map("v", "<leader>gs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		map("v", "<leader>gh", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		map("n", "<leader>gl", function()
			gitsigns.blame_line({ full = true })
		end)

		map("n", "<leader>gS", gitsigns.stage_buffer)
		map("n", "<leader>gr", gitsigns.reset_buffer)
		map("n", "<leader>gp", gitsigns.preview_hunk)
		map("n", "<leader>gi", gitsigns.preview_hunk_inline)
	end,
})

vim.cmd("colorscheme github_dark_dimmed")

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

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

vim.keymap.set("n", "<leader>e", function()
	require("snacks").picker.explorer({ layout = { layout = { position = "right" } } })
end)

vim.keymap.set("n", "<leader>fC", require("snacks").picker.colorschemes)
vim.keymap.set("n", "<leader>fb", require("snacks").picker.buffers)
vim.keymap.set("n", "<leader>fr", require("snacks").picker.recent)
vim.keymap.set("n", "<leader>fw", require("snacks").picker.grep)
vim.keymap.set("n", "<leader>fc", require("snacks").picker.grep_word)
vim.keymap.set("n", "<leader>fn", require("snacks").picker.notifications)
vim.keymap.set("n", "<leader>fg", function()
	require("snacks").picker.git_files({ untracked = true })
end)
vim.keymap.set("n", "<leader>fq", require("snacks").picker.qflist)
vim.keymap.set("n", "<leader>gl", require("snacks").git.blame_line)
vim.keymap.set("n", "<leader>gL", require("snacks").picker.git_log)
vim.keymap.set("n", "<leader>gd", require("snacks").picker.git_diff)
vim.keymap.set("n", "<leader>gb", require("snacks").picker.git_branches)
vim.keymap.set("n", "<leader>gw", require("snacks").picker.git_grep)
vim.keymap.set("n", "<leader>gs", require("snacks").picker.git_status)
vim.keymap.set("n", "<leader>bd", require("snacks").bufdelete.delete)
vim.keymap.set("n", "<leader>bD", require("snacks").bufdelete.all)

vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ timeout = 5000 })
end)

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(_)
		vim.keymap.set("n", "gd", require("snacks").picker.lsp_definitions)
		vim.keymap.set("n", "gr", require("snacks").picker.lsp_references)
		vim.keymap.set("n", "gI", require("snacks").picker.lsp_implementations)
		vim.keymap.set("n", "<leader>lD", require("snacks").picker.lsp_type_definitions)
		vim.keymap.set("n", "<leader>lds", require("snacks").picker.lsp_symbols)
		vim.keymap.set("n", "<leader>lws", require("snacks").picker.lsp_workspace_symbols)
		vim.keymap.set("n", "<leader>lde", require("snacks").picker.diagnostics_buffer)
		vim.keymap.set("n", "<leader>lwe", require("snacks").picker.diagnostics)
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

vim.api.nvim_create_autocmd("LspProgress", {
	buffer = buf,
	callback = function(ev)
		local value = ev.data.params.value

		vim.api.nvim_echo({ { value.message or "done" } }, false, {
			id = "lsp." .. ev.data.params.token,
			kind = "progress",
			source = "vim.lsp",
			title = value.title,
			status = value.kind ~= "end" and "running" or "success",
			percent = value.percentage,
		})
	end,
})

require("nvim-treesitter").install({
	"blade",
	"css",
	"dockerfile",
	"html",
	"ini",
	"json",
	"lua",
	"markdown",
	"php",
	"python",
	"toml",
	"tsx",
	"twig",
	"typescript",
	"vue",
	"xml",
	"yaml",
	"zsh",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

local util = require("conform.util")
require("conform").setup({
	-- log_level = vim.log.levels.DEBUG,
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

vim.lsp.enable("eslint")
vim.lsp.enable("intelephense")
vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("vue_ls")

vim.keymap.set("n", "<leader>dt", function()
	local config = vim.diagnostic.config() or {}
	local new_value = config.virtual_text == false or config.virtual_text == nil
	vim.diagnostic.config({ virtual_text = new_value })
	print("Virtual Text: " .. tostring(new_value))
end, { desc = "Toggle LSP Virtual Text" })

require("lint").linters_by_ft = {
	php = { "phpstan" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

require("blink.cmp").setup({
	completion = {
		menu = {
      auto_show = true,
			draw = {
				components = {
					kind_icon = {
						text = function(ctx)
							local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
							return kind_icon
						end,
						highlight = function(ctx)
							local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
					kind = {
						highlight = function(ctx)
							local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
				},
			},
		},
	},
})

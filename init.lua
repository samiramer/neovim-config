vim.loader.enable()

-- Bootstrap pac-nvim
local pacpath = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if not (vim.uv or vim.loop).fs_stat(pacpath) then
	local pacrepo = "https://github.com/savq/paq-nvim.git"
	local out = vim.fn.system({ "git", "clone", "--depth=1", pacrepo, pacpath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone paq-nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(pacpath)

-- install plugins
require("paq")({
	"savq/paq-nvim",

	-- colorscheme
	"ellisonleao/gruvbox.nvim",
	{ "catppuccin/nvim", as = "catppuccin" },

	-- telescope
	"nvim-lua/plenary.nvim",
	"nvim-telescope/telescope.nvim",
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	"nvim-telescope/telescope-live-grep-args.nvim",
	"nvim-telescope/telescope-ui-select.nvim",

	-- git
	"tpope/vim-fugitive",
	"lewis6991/gitsigns.nvim",

	-- lsp
	"neovim/nvim-lspconfig",
	"mason-org/mason.nvim",
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	"mason-org/mason-lspconfig.nvim",

	-- completions
	{ "saghen/blink.cmp", branch = "v1.3.1" },

	-- formatting and linting
	"stevearc/conform.nvim",
	"mfussenegger/nvim-lint",

	-- dap
	"mfussenegger/nvim-dap",
	"theHamsta/nvim-dap-virtual-text",
	"nvim-telescope/telescope-dap.nvim",
	"rcarriga/nvim-dap-ui",
	"nvim-neotest/nvim-nio",

	-- utilities
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	"nvim-tree/nvim-tree.lua",
	"echasnovski/mini.surround",
	"christoomey/vim-tmux-navigator",
	"tpope/vim-sleuth",
	"tpope/vim-commentary",
	"nvim-lualine/lualine.nvim",
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

vim.filetype.add({
	pattern = {
		["*.blade.php"] = "blade",
	},
})

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

-- colorscheme
-- require("catppuccin").setup()
require("gruvbox").setup({ contrast = "hard", bold = false })
vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")

-- telescope
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

require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("live_grep_args")

-- keymaps - telescope
vim.keymap.set({ "n" }, "<leader>ff", function()
	require("telescope.builtin").find_files({ hidden = true })
end)
vim.keymap.set({ "n" }, "<leader>fF", function()
	require("telescope.builtin").find_files({ hidden = true, follow = true, no_ignore = true, no_ignore_parent = true })
end)
vim.keymap.set({ "n" }, "<leader>fw", function()
	require("telescope").extensions.live_grep_args.live_grep_args({ hidden = true })
end)
vim.keymap.set({ "n" }, "<leader>fb", require("telescope.builtin").buffers)
vim.keymap.set({ "n" }, "<leader>fg", require("telescope.builtin").git_status)
vim.keymap.set({ "n" }, "<leader>fs", function()
	require("telescope.builtin").git_status({ hidden = true })
end)
vim.keymap.set({ "n" }, "<leader>fc", function()
	require("telescope.builtin").colorscheme({ enable_preview = true })
end)

-- git
require("gitsigns").setup({
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
})

-- mason
require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"black",
		"clangd",
		"clang-format",
		"css-lsp",
		"emmet-language-server",
		"eslint-lsp",
		"eslint_d",
		"html-lsp",
		"intelephense",
		"lua-language-server",
		"phpcs",
		"php-cs-fixer",
		"php-debug-adapter",
		"phpstan",
		"pint",
		"prettier",
		"pyright",
		"stylelint-lsp",
		"stylua",
		"tailwindcss-language-server",
		"typescript-language-server",
		"vue-language-server",
	},
	run_on_start = true,
})

-- treesitter
require("nvim-treesitter.configs").setup({
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
})

-- lsp
local servers = {
	clangd = {},
	cssls = {},
	eslint = {},
	stylelint_lsp = {},
	tailwindcss = {},
	pyright = {},
	emmet_language_server = {
		settings = {
			filetypes = {
				"css",
				"eruby",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"pug",
				"typescriptreact",
				"twig",
				"vue",
			},
		},
	},
	intelephense = {
		settings = {
			maxMemory = 8192,
			format = {
				enable = false,
			},
		},
	},
	lua_ls = {
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					version = "LuaJIT",
					path = {
						"lua/?.lua",
						"lua/?/init.lua",
					},
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
					},
				},
			})
		end,
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				diagnostics = { disable = { "missing-fields" } },
			},
		},
	},
	ts_ls = {
		init_options = {
			plugins = {
				{
					name = "@vue/typescript-plugin",
					location = vim.fn.stdpath("data")
						.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
					languages = { "vue" },
					configNamespace = "typescript",
					enableForWorkspaceTypeScriptVersions = true,
				},
			},
			tsserver = {
				logVerbosity = "off",
			},
		},
		filetypes = {
			"javascript",
			"typescript",
			"typescriptreact",
			"javascriptreact",
			"vue",
		},
	},
	vue_ls = {
		init_options = {
			typescript = {
				tsdk = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/typescript/lib/",
			},
		},
	},
}

for server, config in pairs(servers) do
	if next(config) ~= nil then
		vim.lsp.config(server, config)
	end

	vim.lsp.enable(server)
end

vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions)
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references)
vim.keymap.set("n", "gI", require("telescope.builtin").lsp_implementations)
vim.keymap.set("n", "<leader>lD", require("telescope.builtin").lsp_type_definitions)
vim.keymap.set("n", "<leader>lds", require("telescope.builtin").lsp_document_symbols)
vim.keymap.set("n", "<leader>lde", function()
	require("telescope.builtin").diagnostics({ bufnr = 0 })
end)
vim.keymap.set("n", "<leader>lwe", require("telescope.builtin").diagnostics)
vim.keymap.set("n", "<leader>lws", require("telescope.builtin").lsp_dynamic_workspace_symbols)
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

-- formatting
local util = require("conform.util")
require("conform").setup({
	log_level = vim.log.levels.DEBUG,
	formatters_by_ft = {
		c = { "clang-format" },
		lua = { "stylua" },
		php = { "php_cs_fixer", "pint" },
		javascript = { "prettier", "eslint_d" },
		typescript = { "prettier", "eslint_d" },
		javascriptreact = { "prettier", "eslint_d" },
		typescriptreact = { "prettier", "eslint_d" },
		vue = { "prettier", "eslint_d" },
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
		["prettier"] = {
			cwd = util.root_file({
				".prettierrc",
				".prettierrc.json",
				".prettierrc.yml",
				".prettierrc.yaml",
				".prettierrc.json5",
				".prettierrc.js",
				".prettierrc.cjs",
				".prettierrc.mjs",
				".prettierrc.toml",
				"prettier.config.js",
				"prettier.config.cjs",
				"prettier.config.mjs",
			}),
			require_cwd = true,
		},
	},
})

vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ timeout = 5000 })
end)

require("lint").linters_by_ft = {
	php = { "phpstan" },
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

-- nvim-tree
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

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>")

-- completions
require("blink.cmp").setup({
	completion = { documentation = { auto_show = true } },
	fuzzy = { implementation = "prefer_rust_with_warning" },
	sources = {
		default = { "lsp", "buffer", "snippets", "path", "cmdline" },
	},
})

-- dap
require("telescope").load_extension("dap")
local dap = require("dap")
dap.adapters.php = {
	type = "executable",
	command = "php-debug-adapter",
}

dap.configurations.php = {
	{
		type = "php",
		request = "launch",
		name = "DDEV PHP: Listen for Xdebug",
		hostname = "0.0.0.0",
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

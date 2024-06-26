-- Global statusline
vim.o.laststatus = 3

-- change leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- tab and indent settings
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.breakindent = true
vim.o.wrap = false
vim.o.autoindent = true
vim.o.smartindent = true

-- show line numbers
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.signcolumn = "yes"

-- save undo history
vim.o.undofile = true

-- case insensitive search unless /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- decrease update time
vim.o.updatetime = 250

-- disable backups and swap files
vim.o.backup = false
vim.o.swapfile = false
vim.o.writebackup = false

-- enable mouse mode
vim.o.mouse = "a"

vim.o.conceallevel = 2

-- don't show vi mode since we are already showing it on the status line
vim.o.showmode = false

vim.o.colorcolumn = "100"

-- live preview substitions
vim.opt.inccommand = "split"

-- show which line your cursor is on
vim.opt.cursorline = true

-- -- Adjust tab spacing for PHP files
-- vim.api.nvim_create_autocmd("Filetype", {
-- 	pattern = { "php" },
-- 	command = "setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab",
-- })

-- Ease of life keymaps
vim.keymap.set("i", "jk", "<Esc>", { silent = true })
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set({ "n" }, "<leader>h", ":nohlsearch<CR>", { silent = true })

-- Clipboard copy/paste
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { silent = true, desc = "Clipboard yank" })
vim.keymap.set({ "n", "v" }, "<leader>Y", '"+Y', { silent = true, desc = "Clipboard line yank" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { silent = true, desc = "Clipboard paste after cursor" })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { silent = true, desc = "Clipboard paste before cursor" })

-- Stay in indent mode
vim.keymap.set({ "v" }, "<", "<gv", { silent = true, desc = "Indent" })
vim.keymap.set({ "v" }, ">", ">gv", { silent = true, desc = "Reduce indent" })

-- Window splitting
vim.keymap.set("n", "<leader>=", ":split<CR>", { noremap = true, silent = true, desc = "Horizontal split" })
vim.keymap.set("n", "<leader>-", ":vsplit<CR>", { noremap = true, silent = true, desc = "Vertical split" })

-- Toggle the number and sign columns on and off
vim.keymap.set("n", "<leader>tt", function()
	local nu = { number = true, relativenumber = true, signcolumn = "yes" }
	if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
		nu = {
			number = vim.opt_local.number:get(),
			relativenumber = vim.opt_local.relativenumber:get(),
			signcolumn = vim.opt_local.signcolumn:get(),
		}
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
	else
		vim.opt_local.number = nu.number
		vim.opt_local.relativenumber = nu.relativenumber
		vim.opt_local.signcolumn = nu.signcolumn
	end
end, { noremap = true, silent = true, desc = "[T]oggle [s]ide column" })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local options = {}
local plugins = {
	{ -- colorscheme
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		lazy = false,
		config = { contrast = "hard", bold = false },
	},
	{
		"bluz71/vim-nightfly-colors",
		name = "nightfly",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.nightflyNormalFloat = true
			vim.g.nightflyCursorColor = true
			vim.g.nightflyVirtualTextColor = true
			vim.g.nightflyWinSeparator = 2
			vim.opt.fillchars = {
				horiz = "━",
				horizup = "┻",
				horizdown = "┳",
				vert = "┃",
				vertleft = "┫",
				vertright = "┣",
				verthoriz = "╋",
			}
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "single",
			})
			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
				border = "single",
			})
			vim.diagnostic.config({ float = { border = "single" } })

			require("nightfly")
		end,
	},
	{ -- telescope
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				version = "^1.0.0",
			},
		},
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files({ hidden = true })
				end,
				{ desc = "[F]ind [f]iles" },
			},
			{
				"<leader>fw",
				function()
					require("telescope").extensions.live_grep_args.live_grep_args({ hidden = true })
				end,
				{ desc = "[F]ind [w]ords" },
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
				{ desc = "[F]ind [b]uffer" },
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").git_files()
				end,
				{ desc = "[F]ind [G]it file" },
			},
			{
				"<leader>fs",
				function()
					require("telescope.builtin").grep_string({ hidden = true })
				end,
				{ desc = "[F]ind [s]tring under cursor" },
			},
			{
				"<leader>fc",
				function()
					require("telescope.builtin").colorscheme({ enable_preview = true })
				end,
				{ desc = "[F]ind [c]olorscheme" },
			},
		},
		config = function()
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

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension, "live_grep_args")
		end,
	},
	{ -- autocompletions
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-buffer",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				window = {
					completion = cmp.config.window.bordered(winhighlight),
					documentation = cmp.config.window.bordered(winhighlight),
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})
		end,
	},
	{ -- lsp setup
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		cmd = "Mason",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = { progress = { display = { done_ttl = 1 } } } },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>lD", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>lds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map("<leader>lde", function() require("telescope.builtin").diagnostics{bufnr=0} end, "Show [D]ocument Diagnostics")
					map("<leader>lwe", require("telescope.builtin").diagnostics, "Show [W]orkspace Diagnostics")
					map(
						"<leader>lws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>lj", vim.diagnostic.goto_next, "Go to next diagnostic")
					map("<leader>lk", vim.diagnostic.goto_prev, "Go to previous diagnostic")
					map("<leader>le", vim.diagnostic.open_float, "G[e]t line diagnostics")
					map("<leader>lr", vim.lsp.buf.rename, "[R]ename")
					map("<leader>la", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local css_capabilities = vim.lsp.protocol.make_client_capabilities()
			css_capabilities.textDocument.completion.completionItem.snippetSupport = true

			local servers = {
				lua_ls = {
					capabilities = capabilities,
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							diagnostics = { disable = { "missing-fields" } },
						},
					},
				},
				eslint = {
					capabilities = capabilities,
				},
				intelephense = {
					capabilities = capabilities,
					settings = {
						maxMemory = 8192,
						format = {
							enable = false,
						},
					},
				},
				volar = {
					capabilities = capabilities,
					-- settings = {
					-- 	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
					-- },
				},
				emmet_language_server = {
					capabilities = capabilities,
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
				cssls = {
					capabilities = css_capabilities,
				},
				tailwindcss = {
					capabilities = css_capabilities,
				},
				tsserver = {
					capabilities = capabilities,
					init_options = {
						plugins = {
							{
								name = "@vue/typescript-plugin",
								location = os.getenv("HOME")
									.. "/.nvm/versions/node/v20.13.1/lib/node_modules/@vue/typescript-plugin",
								languages = { "typescript", "vue" },
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
			}

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
				"prettier",
				"phpcs",
				"php-cs-fixer",
				"phpstan",
				"php-debug-adapter",
				"stylelint",
				"tsserver",
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	-- {
	-- 	"pmizio/typescript-tools.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	-- 	opts = {},
	-- },
	{ -- code commenting
		"tpope/vim-commentary",
		event = { "BufReadPre", "BufNewFile" },
	},
	{ -- treesitter (syntax highlighting and other nice features)
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			ensure_installed = {
				"bash",
				"lua",
				"html",
				"javascript",
				"json",
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
				disable = function(lang, buf)
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
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{ -- context based commenting support
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = { "BufReadPre", "BufNewFile" },
	},
	{ -- autodetect shiftwidth and tabstop
		"tpope/vim-sleuth",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.g.sleuth_twig_heuristics = 0
		end,
	},
	{ "tpope/vim-fugitive", cmd = "Git" }, -- super useful Git plugin
	{ -- adds git signs to the gutter and other useful git features
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
	{ "christoomey/vim-tmux-navigator", lazy = false }, -- vim keybings to jump between tmux and nvim
	{ -- nice utility plugin with useful modules
		"echasnovski/mini.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- Better Around/Inside textobjects
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			require("mini.surround").setup()
		end,
	},
	{ -- code formatting
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{
				"<leader>lf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
					if vim.fn.exists(":EslintFixAll") > 0 then
						vim.cmd("EslintFixAll")
					end
				end,
				{ desc = "[F]ormat buffer" },
			},
		},
		opts = {
			formatters_by_ft = {
				-- php = { "phpcs" },
				lua = { "stylua" },
				vue = { "prettier" },
				php = { "php_cs_fixer" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				twig = { "prettier" },
			},
		},
	},
	-- { -- code linting
	-- 	"mfussenegger/nvim-lint",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	config = function()
	-- 		local lint = require("lint")

	-- 		lint.linters_by_ft = {
	-- 			-- php = { "phpstan" },
	-- 			vue = { "eslint_d" },
	-- 			javascript = { "eslint_d" },
	-- 			javascriptreact = { "eslint_d" },
	-- 			typescript = { "eslint_d" },
	-- 			typescriptreact = { "eslint_d" },
	-- 		}

	-- 		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "TextChanged" }, {
	-- 			group = vim.api.nvim_create_augroup("lint", { clear = true }),
	-- 			callback = function()
	-- 				lint.try_lint()
	-- 			end,
	-- 		})
	-- 	end,
	-- },
	{ -- Debug adapter protocol support
		"mfussenegger/nvim-dap",
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			{
				"nvim-telescope/telescope-dap.nvim",
				dependencies = { "nvim-telescope/telescope.nvim" },
				config = function()
					require("telescope").load_extension("dap")
				end,
			},
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = "mason.nvim",
				cmd = { "DapInstall", "DapUninstall" },
				opts = {
					automatic_installation = true,
					ensure_installed = { "php" },
				},
			},
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
				keys = {
					{
						"<leader>du",
						function()
							require("dapui").toggle({})
						end,
						desc = "[D]ap [U]I",
					},
					{
						"<leader>de",
						function()
							require("dapui").eval()
						end,
						desc = "[D]AP [e]val",
						mode = { "n", "v" },
					},
				},
				opts = {},
				config = function(_, opts)
					local dap = require("dap")
					local dapui = require("dapui")
					dapui.setup(opts)
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open({})
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close({})
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close({})
					end
				end,
			},
		},
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "[D]AP Toggle [b]reakpoint",
			},
			{
				"<leader>dp",
				function()
					require("dap").list_breakpoints()
				end,
				desc = "[D]AP List [b]reakpoints",
			},
			{
				"<leader>dC",
				function()
					require("dap").clear_breakpoints()
				end,
				desc = "[D]AP [C]lear Breakpoints",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "[D]AP [c]ontinue",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "[D]AP Run [l]ast debugger",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "[D]AP Step [o]ver",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "[D]AP Step [O]ut",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "[D]AP Step [i]nto",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "[D]AP [t]erminate",
			},
			{
				"<leader>dR",
				function()
					require("dap").restart()
				end,
				desc = "[D]AP [R]estart",
			},
			{
				"<leader>dr",
				function()
					require("dap.repl").toggle()
				end,
				desc = "[D]AP Toggle [r]epl",
			},
			{
				"<leader>dh",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "[D]AP [H]over",
			},
		},
		opts = {},
		config = function()
			local dap = require("dap")

			dap.adapters.php = {
				type = "executable",
				command = "php-debug-adapter",
			}

			dap.configurations.php = {
				{
					type = "php",
					request = "launch",
					name = "PHP: Listen for Xdebug",
					hostname = "0.0.0.0",
					port = 9003,
					pathMappings = {
						["/var/www/html"] = "${workspaceFolder}",
					},
				},
			}
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		keys = {
			{
				"<leader>e",
				function()
					require("nvim-tree.api").tree.toggle({ find_file = true })
				end,
				{ desc = "Launch file [e]xplorer" },
			},
		},
		config = function()
			local HEIGHT_RATIO = 0.8 -- You can change this
			local WIDTH_RATIO = 0.25
			require("nvim-tree").setup({
				disable_netrw = true,
				hijack_netrw = true,
				update_focused_file = {
					enable = true,
				},
				filters = {
					dotfiles = false,
				},
				git = {
					ignore = false,
				},
				renderer = {
					group_empty = true,
				},
				view = {
					side = "right",
					width = function()
						return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
					end,
					-- float = {
					-- 	enable = true,
					-- 	open_win_config = function()
					-- 		local screen_w = vim.opt.columns:get()
					-- 		local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
					-- 		local window_w = screen_w * WIDTH_RATIO
					-- 		local window_h = screen_h * HEIGHT_RATIO
					-- 		local window_w_int = math.floor(window_w)
					-- 		local window_h_int = math.floor(window_h)
					-- 		local center_x = (screen_w - window_w) / 2
					-- 		local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
					-- 		return {
					-- 			border = "rounded",
					-- 			relative = "editor",
					-- 			row = center_y,
					-- 			col = center_x,
					-- 			width = window_w_int,
					-- 			height = window_h_int,
					-- 		}
					-- 	end,
					-- },
					-- width = function()
					-- 	return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
					-- end,
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
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			{
				"nvim-telescope/telescope-dap.nvim",
				dependencies = { "nvim-telescope/telescope.nvim" },
				config = function()
					require("telescope").load_extension("dap")
				end,
			},
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = "mason.nvim",
				cmd = { "DapInstall", "DapUninstall" },
				opts = {
					automatic_installation = true,
					ensure_installed = { "php" },
				},
			},
			{
				"rcarriga/nvim-dap-ui",
				-- stylua: ignore
				keys = {
					{ '<leader>du', function() require('dapui').toggle({}) end, desc = 'Dap UI' },
					{ '<leader>de', function() require('dapui').eval() end,     desc = 'Eval',  mode = { 'n', 'v' } },
				},
				opts = {},
				config = function(_, opts)
					local dap = require("dap")
					local dapui = require("dapui")
					dapui.setup(opts)
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open({})
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close({})
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close({})
					end
				end,
			},
		},
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "DAP Toggle Breakpoint",
			},
			{
				"<leader>dp",
				function()
					require("dap").list_breakpoints()
				end,
				desc = "DAP List Breakpoints",
			},
			{
				"<leader>dC",
				function()
					require("dap").clear_breakpoints()
				end,
				desc = "DAP Clear Breakpoints",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "DAP Continue",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "DAP Run Last Debugger",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "DAP Step Over",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "DAP Step Out",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "DAP Step Into",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "DAP Terminate",
			},
			{
				"<leader>dR",
				function()
					require("dap").restart()
				end,
				desc = "DAP Restart",
			},
			{
				"<leader>dr",
				function()
					require("dap.repl").toggle()
				end,
				desc = "DAP Toggle Repl",
			},
			{
				"<leader>dh",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "DAP Hover",
			},
		},
		opts = {},
		config = function()
			local dap = require("dap")

			dap.adapters.php = {
				type = "executable",
				command = "php-debug-adapter",
			}

			dap.configurations.php = {
				{
					type = "php",
					request = "launch",
					name = "PHP: Listen for Xdebug",
					hostname = "0.0.0.0",
					port = 9003,
					pathMappings = {
						["/var/www/html"] = "${workspaceFolder}",
					},
				},
			}
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = { "NvimTree" },
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { { "filename", path = 1 } },
					lualine_c = { "diff", "diagnostics" },
					lualine_x = {
						function()
							local linters = require("lint").get_running()
							local client_list = {}

							for _, client in ipairs(vim.lsp.get_active_clients()) do
								table.insert(client_list, client.name)
							end

							local lint_status = ""

							if #linters > 0 then
								lint_status = "  󰦕 " .. table.concat(linters, ", ")
							end

							return "󱉶 " .. table.concat(client_list, ", ") .. lint_status
						end,
						"branch",
						"encoding",
						"fileformat",
						"filetype",
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
}

require("lazy").setup(plugins, options)

vim.cmd.colorscheme("nightfly")

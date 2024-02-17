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

-- Load plugins
local opts = {}
local plugins = {
	-- catppuccin colorscheme
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },

	-- kanagawa colorscheme
	{ "rebelot/kanagawa.nvim", priority = 1000, config = true },

	-- gruvbox colorscheme
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = { contrast = "hard", bold = false } },

	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-live-grep-args.nvim",
		},
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files()
				end,
			},
			{
				"<leader>fw",
				function()
					require("telescope.builtin").live_grep()
				end,
			},
			{
				"<leader>fc",
				function()
					require("telescope.builtin").grep_string()
				end,
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
			},
			{
				"<leader>fd",
				function()
					require("telescope.builtin").diagnostics()
				end,
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").git_status()
				end,
			},
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				path_display = { "truncate " },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
				defaults = {
					layout_config = {
						horizontal = {
							height = 0.95,
							preview_cutoff = 60,
							width = 0.95,
						},
					},
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("live_grep_args")
		end,
	},

	-- nicer buffer delete
	{
		"famiu/bufdelete.nvim",
		keys = {
			{ "<leader>cc", "<cmd>Bdelete<cr>", {} },
		},
	},

	-- easy vim and tmux naviation
	{ "christoomey/vim-tmux-navigator", lazy = false },

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		version = false,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"html",
				"javascript",
				"json",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"php",
				"tsx",
				"twig",
				"tsx",
				"typescript",
				"vim",
				"vue",
				"vimdoc",
				"yaml",
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	-- file explorer
	{
		"nvim-tree/nvim-tree.lua",
		-- dependencies = { 'nvim-tree/nvim-web-devicons' },
		lazy = false,
		keys = {
			{ "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>" },
		},
		opts = {
			disable_netrw = true,
			hijack_netrw = true,
			filters = {
				dotfiles = false,
			},
			view = {
				width = 50,
				float = {
					enable = false,
					quit_on_focus_loss = true,
					open_win_config = {
						relative = "editor",
						border = "rounded",
						width = 60,
						height = 30,
						row = 1,
						col = 1,
					},
				},
			},
			git = {
				ignore = false,
			},
			renderer = {
				group_empty = true,
				-- icons = {
				--   show = {
				--     folder_arrow = false,
				--   },
				-- },
				indent_markers = {
					enable = true,
				},
			},
			update_focused_file = {
				enable = true,
			},
		},
		config = function(_, opts)
			require("nvim-tree").setup(opts)

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

	-- lsp
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"nvimtools/none-ls.nvim",
			"jay-babu/mason-null-ls.nvim",
			"folke/neodev.nvim",
			-- Additional json LS schemas
			"b0o/schemastore.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				automatic_installation = true,
				ensure_installed = {
					"tsserver",
					"jsonls",
					"volar",
					"lua_ls",
					"intelephense",
					"efm",
					"cssls",
					"emmet_language_server",
					"tailwindcss",
				},
			})

			require("neodev").setup()

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.intelephense.setup({
				capabilities = capabilities,
				settings = {
					maxMemory = 8192,
					format = {
						enable = false,
					},
				},
			})

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})

			lspconfig.tsserver.setup({
				capabilities = capabilities,
			})

			lspconfig.jsonls.setup({
				capabilities = capabilities,
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
					},
				},
			})

			lspconfig.volar.setup({
				capabilities = capabilities,
				settings = {
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
				},
			})

			lspconfig.emmet_language_server.setup({
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
			})

			local css_capabilities = vim.lsp.protocol.make_client_capabilities()
			css_capabilities.textDocument.completion.completionItem.snippetSupport = true

			lspconfig.cssls.setup({
				capabilities = css_capabilities,
			})

			lspconfig.tailwindcss.setup({
				capabilities = css_capabilities,
			})

			require("mason-null-ls").setup({
				automatic_installation = true,
				ensure_installed = {
					"stylua",
					"eslint_d",
					"prettierd",
					"phpcsfixer",
					"twigcs",
				},
			})

			local null_ls = require("null-ls")
			null_ls.setup({
				debug = true,
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettierd.with({
						filetypes = vim.list_extend(null_ls.builtins.formatting.prettier.filetypes, { "twig" }),
					}),
					null_ls.builtins.formatting.eslint_d,
					null_ls.builtins.formatting.phpcsfixer,
					null_ls.builtins.diagnostics.twigcs,
					null_ls.builtins.diagnostics.eslint_d,
					null_ls.builtins.diagnostics.trail_space.with({
						disabled_filetypes = { "NvimTree", "text", "log" },
					}),
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(event)
					vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local o = { buffer = event.buf }
					vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, o)
					vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, o)
					vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, o)
					vim.keymap.set("n", "<leader>lf", function()
						vim.lsp.buf.format({ async = true })
					end, o)

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, o)
					vim.keymap.set("n", "<leader>lD", vim.lsp.buf.type_definition, o)
					vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, o)
					vim.keymap.set("n", "gI", vim.lsp.buf.implementation, o)

					vim.keymap.set("n", "<leader>lD", vim.lsp.buf.type_definition, o)
					vim.keymap.set("n", "<leader>lde", require("telescope.builtin").diagnostics, o)
					vim.keymap.set("n", "<leader>lds", require("telescope.builtin").lsp_document_symbols, o)
					vim.keymap.set("n", "<leader>lws", require("telescope.builtin").lsp_dynamic_workspace_symbols, o)

					vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, o)
					vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, o)

					vim.keymap.set("n", "K", vim.lsp.buf.hover, o)
					vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, o)
					vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, o)

					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, o)
				end,
			})
		end,
	},

	-- git integrations
	{
		"tpope/vim-fugitive",
		lazy = false,
	},
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
				vim.keymap.set("n", "<leader>gl", function()
					gs.blame_line({ full = true })
				end)
				vim.keymap.set("n", "<leader>gd", gs.diffthis)
				vim.keymap.set("n", "<leader>gD", function()
					gs.diffthis("~")
				end)
				vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		},
	},

	-- autocompletions
	{
		"hrsh7th/nvim-cmp",
		version = false,
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-omni",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			-- nvim-cmp setup
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			local winhighlight = {
				winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
			}

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
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-1),
					["<C-f>"] = cmp.mapping.scroll_docs(1),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<C-Space>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
					["<Tab>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default mapping.
					["<S-Tab>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default mapping.
					["<C-j>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-k>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer" },
					{ name = "omni" },
				},
			})
			-- `/` cmdline setup.
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- `:` cmdline setup.
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

	-- code commenting
	{
		"tpope/vim-commentary",
		event = { "BufReadPre", "BufNewFile" },
	},

	-- obsidian
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter",
		},
		keys = {
			{
				"<leader>ot",
				":ObsidianToday<CR>",
			},
		},
		opts = {
			workspaces = {
				{
					name = "master",
					path = "~/Notes/master-vault",
				},
			},
			daily_notes = {
				-- Optional, if you keep daily notes in a separate directory.
				folder = "daily-notes",
			},
		},
	},

	-- smooth scrolling
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({ easing_function = "sine" })
		end,
	},

	-- surround selections
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	-- autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
	},

	-- auto tagging
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- require("lualine").setup({})
		end,
	},

	-- harpoon
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			local harpoon = require("harpoon")

			-- REQUIRED
			harpoon:setup()
			-- REQUIRED

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():append()
			end)
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<C-1>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<C-2>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<C-3>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<C-4>", function()
				harpoon:list():select(4)
			end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-P>", function()
				harpoon:list():prev()
			end)
			vim.keymap.set("n", "<C-N>", function()
				harpoon:list():next()
			end)

			-- basic telescope configuration
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			vim.keymap.set("n", "<C-e>", function()
				toggle_telescope(harpoon:list())
			end, { desc = "Open harpoon window" })
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
}

require("lazy").setup(plugins, opts)

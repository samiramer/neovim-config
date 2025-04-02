return {
	{
		"phpactor/phpactor",
		ft = "php",
		cond = function()
			return vim.fn.executable("composer") == 1
		end,
		build = "composer install --no-dev -o",
	},
	{ -- lsp setup
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		cmd = "Mason",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"nvimtools/none-ls.nvim",
			{ "j-hui/fidget.nvim", opts = { progress = { display = { done_ttl = 1 } } } },
			{ "folke/neodev.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- add keymaps once an LSP client gets attached
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(mode, keys, func, desc)
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("n", "gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("n", "gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("n", "<leader>lD", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("n", "<leader>lds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map("n", "<leader>lde", function()
						require("telescope.builtin").diagnostics({ bufnr = 0 })
					end, "Show [D]ocument Diagnostics")
					map("n", "<leader>lwe", require("telescope.builtin").diagnostics, "Show [W]orkspace Diagnostics")
					map(
						"n",
						"<leader>lws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("n", "<leader>lj", vim.diagnostic.goto_next, "Go to next diagnostic")
					map("n", "<leader>lk", vim.diagnostic.goto_prev, "Go to previous diagnostic")
					map("n", "<leader>le", vim.diagnostic.open_float, "G[e]t line diagnostics")
					map("n", "<leader>lr", vim.lsp.buf.rename, "[R]ename")
					map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("n", "K", vim.lsp.buf.hover, "Hover Documentation")

					map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Create a command `:Format` local to the LSP buffer
					vim.api.nvim_buf_create_user_command(0, "Format", function(_)
						vim.lsp.buf.format({ timeout_ms = 5000 })
						-- vim.lsp.buf.format {
						--   filter = function(client) return client.name ~= "intelephense" end
						-- }
						if vim.fn.exists(":EslintFixAll") > 0 then
							vim.cmd("EslintFixAll")
						end
					end, { desc = "Format current buffer with LSP" })

					map("n", "<leader>lf", ":Format<CR>", "LSP Format current buffer")

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
			local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

			if ok and cmp_nvim_lsp then
				capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
			end

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
				eslint_d = {
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
				ts_ls = {
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

			require("null-ls").setup({
				debug = true,
				sources = {
					require("null-ls").builtins.formatting.stylua,
					require("null-ls").builtins.formatting.phpcsfixer.with({
						env = { PHP_CS_FIXER_IGNORE_ENV = "True" },
						condition = function(utils)
							return utils.root_has_file({ ".php-cs-fixer.php" })
						end,
					}),
					require("null-ls").builtins.formatting.prettier.with({
						filetypes = {
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
							"vue",
							"css",
							"scss",
							"less",
							"html",
							"json",
							"jsonc",
							"yaml",
							"markdown",
							"markdown.mdx",
							"graphql",
							"handlebars",
							"svelte",
							"astro",
							"twig",
						},
						condition = function(utils)
							return utils.root_has_file({ ".prettierrc" })
						end,
					}),
				},
			})

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
				"typescript-language-server",
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
}

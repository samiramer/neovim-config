return {
	{ -- phpactor for introspection
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
			"nvimtools/none-ls.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = { progress = { display = { done_ttl = 1 } } } },
			{ "folke/neodev.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()

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
				clangd = {
					capabilities = capabilities,
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
					settings = {
						filetypes = { "typescript", "javascript", "vue" },
					},
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
				stylelint_lsp = {
					capabilities = capabilities,
				},
				ts_ls = {
					capabilities = capabilities,
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
				twiggy_language_server = {
					capabilities = capabilities,
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

			require("mason-tool-installer").setup {
				ensure_installed = {
					"stylua",
					"prettier",
					"phpcs",
					"php-cs-fixer",
					"phpstan",
					"php-debug-adapter",
					"stylelint",
				}
			}

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers or {}),
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

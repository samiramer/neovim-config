return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
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

					local options = function(desc)
						desc = desc or ""
						return { buffer = event.buf, desc = desc }
					end

					vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, options("Rename symbol"))
					vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, options("Code action"))
					vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, options("Line diagnostics"))
					vim.keymap.set("n", "<leader>lf", function()
						vim.lsp.buf.format({ async = true })
					end, options("Format file"))

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, options("Go to definition"))
					vim.keymap.set("n", "<leader>lD", vim.lsp.buf.type_definition, options("Go to type definition"))
					vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, options("Show references"))
					vim.keymap.set("n", "gI", vim.lsp.buf.implementation, options("Show implementation"))

					vim.keymap.set(
						"n",
						"<leader>lde",
						require("telescope.builtin").diagnostics,
						options("Show document diagnostics")
					)
					vim.keymap.set(
						"n",
						"<leader>lds",
						require("telescope.builtin").lsp_document_symbols,
						options("Show document symbols")
					)
					vim.keymap.set(
						"n",
						"<leader>lws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						options("Show workspace symbols")
					)

					vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, options("Show next diagnostic"))
					vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, options("Show previous diagnostic"))

					vim.keymap.set("n", "K", vim.lsp.buf.hover, options("Hover"))
					vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, options("Signature help"))

					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, options("Go to declaration"))
				end,
			})
		end,
	},
	{
		"SmiteshP/nvim-navic",
		dependencies = "neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		config = function()
			require("nvim-navic").setup({ lsp = { auto_attach = true } })
			vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
		end,
	},
}

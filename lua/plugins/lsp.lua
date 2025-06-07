return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
		},
		config = function()
			local servers = {
				clangd = {},
				cssls = {},
				eslint = {},
				stylelint_lsp = {},
				tailwindcss = {},
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
					on_init = require("utils").lsp_lua_on_init,
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
							tsdk = vim.fn.stdpath("data")
								.. "/mason/packages/vue-language-server/node_modules/typescript/lib/",
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
					map("n", "<leader>lj", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, "Go to next diagnostic")
					map("n", "<leader>lk", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, "Go to previous diagnostic")
					map("n", "<leader>le", vim.diagnostic.open_float, "G[e]t line diagnostics")
					map("n", "<leader>lr", vim.lsp.buf.rename, "[R]ename")
					map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("n", "K", vim.lsp.buf.hover, "Hover Documentation")

					map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- -- Create a command `:Format` local to the LSP buffer
					-- vim.api.nvim_buf_create_user_command(0, "Format", function(_)
					--   vim.lsp.buf.format({ timeout_ms = 5000 })

					--   if vim.fn.exists(":EslintFixAll") > 0 then
					--     vim.cmd("EslintFixAll")
					--   end
					-- end, { desc = "Format current buffer with LSP" })

					-- map("n", "<leader>lf", ":Format<CR>", "LSP Format current buffer")

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

					if client and client.server_capabilities.signatureHelpProvider then
						vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature help" })
						vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
					end
				end,
			})
		end,
	},
}

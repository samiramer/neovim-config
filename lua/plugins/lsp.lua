return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"folke/neodev.nvim",
		"mhartington/formatter.nvim",
		"creativenull/efmls-configs-nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local on_attach = function(_, bufnr)
			vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

			local opts = { buffer = bufnr }
			vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)

			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
			vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)

			vim.keymap.set("n", "<leader>lD", vim.lsp.buf.type_definition, opts)
			vim.keymap.set("n", "<leader>lds", require("telescope.builtin").lsp_document_symbols, opts)
			vim.keymap.set("n", "<leader>lws", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)

			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, opts)

			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "<leader>lf", function()
				vim.lsp.buf.format({ timeout_ms = 5000 })
			end, opts)
		end

		require("mason").setup()
		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = { "volar", "lua_ls", "intelephense" },
		})

		require("neodev").setup()

		local lspconfig = require("lspconfig")
		lspconfig.intelephense.setup({
			on_attach = on_attach,
			settings = {
				maxMemory = 4096,
				format = {
					enable = false,
				},
			},
		})

		lspconfig.lua_ls.setup({
			on_attach = on_attach,
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		})

		lspconfig.volar.setup({
			on_attach = on_attach,
			settings = {
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			},
		})

		-- Register linters and formatters per language
		local eslint = require("efmls-configs.linters.eslint")
		local eslint_fmt = require("efmls-configs.formatters.eslint")
		local prettier = require("efmls-configs.formatters.prettier")
		local stylua = require("efmls-configs.formatters.stylua")
		local phpcsfixer = require("efmls-configs.formatters.php_cs_fixer")
		local languages = {
			typescript = { eslint, eslint_fmt, prettier },
			typescriptreact = { eslint, eslint_fmt, prettier },
			javascript = { eslint, eslint_fmt, prettier },
			javascriptreact = { eslint, eslint_fmt, prettier },
			vue = { eslint, eslint_fmt, prettier },
			php = { phpcsfixer },
			lua = { stylua },
		}

		lspconfig.efm.setup({
			on_attach = on_attach,
			filetypes = vim.tbl_keys(languages),
			settings = {
				rootMarkers = { ".git/" },
				languages = languages,
			},
			init_options = {
				documentFormatting = true,
				documentRangeFormatting = true,
				hover = true,
				documentSymbol = true,
				codeAction = true,
				completion = true,
			},
		})

		--		local function prettier_package_json_key_exists(project_root)
		--			local ok, has_prettier_key = pcall(function()
		--				local package_json_blob =
		--					table.concat(vim.fn.readfile(require("lspconfig.util").path.join(project_root, "/package.json")))
		--				local package_json = vim.json.decode(package_json_blob) or {}
		--				return not not package_json.prettier
		--			end)
		--			return ok and has_prettier_key
		--		end
		--
		--		local function prettier_config_file_exists(project_root)
		--			return (not not project_root) and vim.tbl_count(vim.fn.glob(".prettierrc*", true, true)) > 0
		--				or vim.tbl_count(vim.fn.glob("prettier.config.*", true, true)) > 0
		--		end
		--
		--		local function prettier()
		--			local startpath = vim.fn.getcwd()
		--			local project_root = (
		--				require("lspconfig.util").find_git_ancestor(startpath)
		--				or require("lspconfig.util").find_package_json_ancestor(startpath)
		--			)
		--			if prettier_config_file_exists(project_root) or prettier_package_json_key_exists(project_root) then
		--				return require("formatter.defaults.prettier")()
		--			end
		--		end
		--
		--		require("formatter").setup({
		--			filetype = {
		--				lua = {
		--					require("formatter.filetypes.lua").stylua,
		--				},
		--				php = {
		--					require("formatter.filetypes.php").php_cs_fixer,
		--				},
		--				javascript = {
		--					require("formatter.filetypes.javascript").eslint_d,
		--					prettier,
		--				},
		--				javascriptreact = {
		--					require("formatter.filetypes.javascript").eslint_d,
		--					prettier,
		--				},
		--				typescript = {
		--					require("formatter.filetypes.typescript").eslint_d,
		--					prettier,
		--				},
		--				typescriptreact = {
		--					require("formatter.filetypes.typescript").eslint_d,
		--					prettier,
		--				},
		--				vue = {
		--					require("formatter.filetypes.typescript").eslint_d,
		--					prettier,
		--        }
		--			},
		--		})
		--
		--    vim.keymap.set("n", "<leader>lf", ":Format<cr>")

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
				vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)

				vim.keymap.set("n", "<leader>lD", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<leader>lds", require("telescope.builtin").lsp_document_symbols, opts)
				vim.keymap.set("n", "<leader>lws", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)

				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, opts)

				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "<leader>lf", function()
					vim.lsp.buf.format({ timeout_ms = 5000 })
				end, opts)
			end,
		})
	end,
}

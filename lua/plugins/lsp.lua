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
		require("mason").setup()
		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = { "volar", "lua_ls", "intelephense" },
		})

		require("neodev").setup()

		local lspconfig = require("lspconfig")
		lspconfig.intelephense.setup({
			settings = {
				maxMemory = 4096,
				format = {
					enable = false,
				},
			},
		})

		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		})

		lspconfig.volar.setup({
			settings = {
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			},
		})

		-- Register linters language
		local eslint = require("efmls-configs.linters.eslint_d")
		local languages = {
			typescript = { eslint },
			typescriptreact = { eslint },
			javascript = { eslint },
			javascriptreact = { eslint },
			vue = { eslint },
		}

		-- Use efm for linting
		lspconfig.efm.setup({
			filetypes = vim.tbl_keys(languages),
			settings = {
				rootMarkers = { ".git/" },
				languages = languages,
			},
			init_options = {
				-- don't use efm for formatting
				documentFormatting = false,
				documentRangeFormatting = false,
				hover = true,
				documentSymbol = true,
				codeAction = true,
				completion = true,
			},
		})

		local function prettier_package_json_key_exists(project_root)
			local ok, has_prettier_key = pcall(function()
				local package_json_blob =
					table.concat(vim.fn.readfile(require("lspconfig.util").path.join(project_root, "/package.json")))
				local package_json = vim.json.decode(package_json_blob) or {}
				return not not package_json.prettier
			end)
			return ok and has_prettier_key
		end

		local function prettier_config_file_exists(project_root)
			return (not not project_root) and vim.tbl_count(vim.fn.glob(".prettierrc*", true, true)) > 0
				or vim.tbl_count(vim.fn.glob("prettier.config.*", true, true)) > 0
		end

		local function prettier()
			local startpath = vim.fn.getcwd()
			local project_root = (
				require("lspconfig.util").find_git_ancestor(startpath)
				or require("lspconfig.util").find_package_json_ancestor(startpath)
			)
			if prettier_config_file_exists(project_root) or prettier_package_json_key_exists(project_root) then
				return require("formatter.defaults.prettier")()
			end
		end

		require("formatter").setup({
			filetype = {
				lua = {
					require("formatter.filetypes.lua").stylua,
				},
				php = {
					require("formatter.filetypes.php").php_cs_fixer,
				},
				javascript = {
					prettier,
					require("formatter.filetypes.javascript").eslint_d,
				},
				javascriptreact = {
					prettier,
					require("formatter.filetypes.javascript").eslint_d,
				},
				typescript = {
					prettier,
					require("formatter.filetypes.typescript").eslint_d,
				},
				typescriptreact = {
					prettier,
					require("formatter.filetypes.typescript").eslint_d,
				},
				vue = {
					prettier,
					require("formatter.filetypes.typescript").eslint_d,
				},
				twig = {
					prettier,
				},
			},
		})

		vim.keymap.set("n", "<leader>lf", ":Format<cr>")

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
			end,
		})
	end,
}

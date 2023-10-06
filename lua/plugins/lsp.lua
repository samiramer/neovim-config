return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"folke/neodev.nvim",
		"creativenull/efmls-configs-nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = { "volar", "lua_ls", "intelephense", "efm" },
		})

		require("neodev").setup()

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		local lspconfig = require("lspconfig")
		lspconfig.intelephense.setup({
      capabilities = capabilities,
			settings = {
				maxMemory = 4096,
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

		lspconfig.volar.setup({
      capabilities = capabilities,
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
      capabilities = capabilities,
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

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, opts)

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<leader>lD", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
				vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)

				vim.keymap.set("n", "<leader>lD", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<leader>lde", require("telescope.builtin").diagnostics, opts)
				vim.keymap.set("n", "<leader>lds", require("telescope.builtin").lsp_document_symbols, opts)
				vim.keymap.set("n", "<leader>lws", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)

				vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, opts)
				vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, opts)

				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, opts)

				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			end,
		})
	end,
}

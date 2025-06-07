return {
	{
		"stevearc/conform.nvim",
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>lf",
				function()
					require("conform").format({ timeout = 3000 })
				end,
				mode = { "n", "v" },
				{ desc = "[F]ind [f]iles" },
			},
		},
		config = function()
			local util = require("conform.util")

			require("conform").setup({
				log_level = vim.log.levels.DEBUG,
				formatters_by_ft = {
					c = { "clang-format" },
					lua = { "stylua" },
					php = { "php_cs_fixer" },
					javascript = { "prettier", "eslint_d" },
					typescript = { "prettier", "eslint_d" },
					javascriptreact = { "prettier", "eslint_d" },
					typescriptreact = { "prettier", "eslint_d" },
					vue = { "prettier", "eslint_d" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					markdown = { "prettier" },
				},
				formatters = {
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
		end,
	},
}

return {
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = vim.fn.stdpath("data")
					.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
				languages = { "vue" },
				configNamespace = "typescript",
			},
		},
		preferences = {
			importModuleSpecifierPreference = "non-relative",
			importModuleSpecifierEnding = "minimal",
		},
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	settings = {
		typescript = {
			preferences = {
				importModuleSpecifierPreference = "non-relative",
			},
		},
		javascript = {
			preferences = {
				importModuleSpecifierPreference = "non-relative",
			},
		},
	},
}

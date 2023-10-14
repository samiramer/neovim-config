return {
	{
		"mhartington/formatter.nvim",
		config = function()
			local function prettier_package_json_key_exists(project_root)
				local ok, has_prettier_key = pcall(function()
					local package_json_blob = table.concat(
						vim.fn.readfile(require("lspconfig.util").path.join(project_root, "/package.json"))
					)
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
					c = {
						require("formatter.filetypes.c").clangformat,
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
		end,
	},
}

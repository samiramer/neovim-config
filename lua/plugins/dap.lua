return {
	{ -- Debug adapter protocol support
		"mfussenegger/nvim-dap",
		lazy = true,
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			{
				"nvim-telescope/telescope-dap.nvim",
				lazy = true,
				dependencies = { "nvim-telescope/telescope.nvim" },
				config = function()
					require("telescope").load_extension("dap")
				end,
			},
			{
				"rcarriga/nvim-dap-ui",
				lazy = true,
				dependencies = { "nvim-neotest/nvim-nio" },
				keys = {
					{
						"<leader>du",
						function()
							require("dapui").toggle({})
						end,
						desc = "[D]ap [U]I",
					},
					{
						"<leader>de",
						function()
							require("dapui").eval()
						end,
						desc = "[D]AP [e]val",
						mode = { "n", "v" },
					},
				},
				opts = {},
				config = function(_, opts)
					local dap = require("dap")
					local dapui = require("dapui")
					dapui.setup(opts)
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open({})
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close({})
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close({})
					end
				end,
			},
		},
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "[D]AP Toggle [b]reakpoint",
			},
			{
				"<leader>dp",
				function()
					require("dap").list_breakpoints()
				end,
				desc = "[D]AP List [b]reakpoints",
			},
			{
				"<leader>dC",
				function()
					require("dap").clear_breakpoints()
				end,
				desc = "[D]AP [C]lear Breakpoints",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "[D]AP [c]ontinue",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "[D]AP Run [l]ast debugger",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "[D]AP Step [o]ver",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "[D]AP Step [O]ut",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "[D]AP Step [i]nto",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "[D]AP [t]erminate",
			},
			{
				"<leader>dR",
				function()
					require("dap").restart()
				end,
				desc = "[D]AP [R]estart",
			},
			{
				"<leader>dr",
				function()
					require("dap.repl").toggle()
				end,
				desc = "[D]AP Toggle [r]epl",
			},
			{
				"<leader>dh",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "[D]AP [H]over",
			},
			{
				"<leader>da",
				function()
					require("dap").set_exception_breakpoints({ "Warning", "Error", "Exception" })
				end,
				desc = "[D]AP break on PHP exception",
			},
		},
		opts = {},
		config = function()
			local dap = require("dap")
			-- dap.defaults.php.exception_breakpoints = { "Notice", "Warning", "Error", "Exception" }

			dap.adapters.php = {
				type = "executable",
				command = "php-debug-adapter",
			}

			dap.configurations.php = {
				{
					type = "php",
					request = "launch",
					name = "DDEV PHP: Listen for Xdebug",
					hostname = "0.0.0.0",
					port = 9003,
					pathMappings = {
						["/var/www/html"] = "${workspaceFolder}",
					},
				},
			}
		end,
	},
}


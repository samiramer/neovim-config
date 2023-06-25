return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'theHamsta/nvim-dap-virtual-text',
      {
        'nvim-telescope/telescope-dap.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = function()
          require('telescope').load_extension('dap')
        end
      },
      {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = 'mason.nvim',
        cmd = { 'DapInstall', 'DapUninstall' },
        opts = {
          automatic_installation = true,
          ensure_installed = { 'php' }
        },
      },
      {
        'rcarriga/nvim-dap-ui',
        -- stylua: ignore
        keys = {
          { '<leader>du', function() require('dapui').toggle({}) end, desc = 'Dap UI' },
          { '<leader>de', function() require('dapui').eval() end,     desc = 'Eval',  mode = { 'n', 'v' } },
        },
        opts = {},
        config = function(_, opts)
          local dap = require('dap')
          local dapui = require('dapui')
          dapui.setup(opts)
          dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close({})
          end
        end,
      },
    },
    keys = {
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'DAP Toggle Breakpoint' },
      { '<leader>dp', function() require('dap').list_breakpoints() end,  desc = 'DAP List Breakpoints' },
      { '<leader>dC', function() require('dap').clear_breakpoints() end, desc = 'DAP Clear Breakpoints' },
      { '<leader>dc', function() require('dap').continue() end,          desc = 'DAP Continue' },
      { '<leader>dl', function() require('dap').run_last() end,          desc = 'DAP Run Last Debugger' },
      { '<leader>do', function() require('dap').step_over() end,         desc = 'DAP Step Over' },
      { '<leader>dO', function() require('dap').step_out() end,          desc = 'DAP Step Out' },
      { '<leader>di', function() require('dap').step_into() end,         desc = 'DAP Step Into' },
      { '<leader>dt', function() require('dap').terminate() end,         desc = 'DAP Terminate' },
      { '<leader>dR', function() require('dap').restart() end,           desc = 'DAP Restart' },
      { '<leader>dr', function() require('dap.repl').toggle() end,       desc = 'DAP Toggle Repl' },
      { '<leader>dh', function() require('dap.ui.widgets').hover() end,  desc = 'DAP Hover' },
    },
    opts = {

    },
    config = function()
      local dap = require('dap')

      dap.adapters.php = {
        type = 'executable',
        command = 'php-debug-adapter',
      }

      dap.configurations.php = {
        {
          type = 'php',
          request = 'launch',
          name = 'PHP 7.0: Listen for Xdebug',
          port = 9070,
        },
        {
          type = 'php',
          request = 'launch',
          name = 'PHP 8.0: Listen for Xdebug',
          port = 9080,
        },
        {
          type = 'php',
          request = 'launch',
          name = 'PHP 8.1: Listen for Xdebug',
          port = 9081,
        },
        {
          type = 'php',
          request = 'launch',
          name = 'PHP 8.2: Listen for Xdebug',
          port = 9082,
        },
      }
    end
  }
}

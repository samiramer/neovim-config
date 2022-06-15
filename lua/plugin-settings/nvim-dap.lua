local status_ok, dap = pcall(require, "dap")
if not status_ok then
	return
end

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { os.getenv('HOME') .. '/.local/share/dap/vscode-php-debug/out/phpDebug.js' }
}

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for xdebug',
    port = '9003',
    log = true,
    serverSourceRoot = '/home/vagrant/code/',
    localSourceRoot = '/Users/samer/Code/'
  },
}

dap.set_log_level('TRACE')

local dapui_ok, dapui = pcall(require, "dapui")
if not dapui_ok then
	return
end

dapui.setup()


local status_ok, dap_install = pcall(require, "dap-install")
if not status_ok then
	return
end

dap_install.config("php", {
  configurations = {
    {
      type = 'php',
      request = 'launch',
      name = 'Listen for Xdebug',
      port = 9003,
      key = 'PHPSTORM'
    }
  }
})


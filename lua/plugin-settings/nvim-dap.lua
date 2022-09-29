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
  },
  {
    type = 'php',
    request = 'launch',
    name = 'Launch currently open script',
    program = "${file}",
    cwd = "${fileDirName}",
    port = '9003',
  },
}

dap.adapters.chrome = {
    type = "executable",
    command = "node",
    args = {os.getenv("HOME") .. "/.local/share/dap/vscode-chrome-debug/out/src/chromeDebug.js"} -- TODO adjust
}

dap.configurations.javascriptreact = { -- change this to javascript if needed
    {
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}"
    }
}

dap.configurations.typescriptreact = { -- change to typescript if needed
    {
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}"
    }
}

local dapui_ok, dapui = pcall(require, "dapui")
if not dapui_ok then
	return
end

dapui.setup()

local dapvt_ok, dapvt = pcall(require, "nvim-dap-virtual-text")
if not dapvt_ok then
	return
end

dapvt.setup {
  enabled = true
}


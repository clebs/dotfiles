-- UI
require('dapui').setup()

local dap = require('dap')

-- Adapters
dap.adapters.lldb = {
  type = 'server',
  name = 'lldb',
  host = '127.0.0.1',
  port = 13000,
  executable = {
    command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
    args = { "--port", '13000' },
  }
}

dap.adapters.go = {
  type = 'server',
  port = 38555,
  executable = {
    command = vim.fn.exepath('dlv'),
    detached = true,
    args = { 'dap', '-l', '127.0.0.1:38555' }
  },
  options = {
    initialize_timeout_sec = 20,
  },
}
-- Adapter to connect to a remote dlv debugger
dap.adapters.go_remote = function(cb, config)
  if config.request == 'attach' then
    if config.port == '' then config.port = 2345 end -- default dlv remote port
    if config.host == '' then config.host = '127.0.0.1' end
    -- Attach without running any dlv process to try connecting to a running one.
    cb({
      type = 'server',
      port = config.port,
      host = config.host,
    })
  else
    cb({
      type = "server",
      port = config.delve.port,
      executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:" .. config.delve.port },
      },
      options = {
        initialize_timeout_sec = config.delve.initialize_timeout_sec,
      },
    })
  end
end

-- Configurations
dap.configurations.go = {
  {
    type = 'go',
    name = 'Debug',
    request = 'launch',
    program = '${workspaceFolder}', -- Runs the whole package
    outputMode = 'remote',
  },
  {
    type = 'go',
    name = 'Debug Current File',
    request = 'launch',
    program = '${file}', -- Runs the current file
    -- get input args as string and split it into space separated array for adapter args.
    args = function() return vim.split(vim.fn.input('Debug args:') or "", " ") end,
  },
  {
    type = "go",
    name = "Debug Test",
    request = "launch",
    mode = "test",
    program = '${file}',
    -- get input args as string and split it into space separated array for adapter args.
    args = function() return vim.split(vim.fn.input('Debug test args:') or "", " ") end,
  },
  {
    name = "Remote debug",
    type = "go_remote",
    request = "attach",
    mode = "remote",
    remotePath = "${workspaceFolder}",
    host = function() return vim.fn.input('Remote debugger host:') end,
    port = function() return vim.fn.input('Remote debugger port:') end,
  },
}

dap.configurations.zig = {
  {
    type = 'lldb',
    request = 'launch',
    name = "Launch file",
    cwd = '${workspaceFolder}',
    args = {},
    program = function()
      return vim.fn.input('Program to debug: ')
    end,
  },
}

local dap = require('dap')

-- Debuggers
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

-- configurations
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

-- Append configuration to existing ones at nvim-dap-go
table.insert(dap.configurations.go, {
  name = "Remote debug",
  type = "go_remote",
  request = "attach",
  mode = "remote",
  remotePath = "${workspaceFolder}",
  host = function() return vim.fn.input('Remote debugger host:') end,
  port = function() return vim.fn.input('Remote debugger port:') end,
})

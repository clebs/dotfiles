local dap = require('dap')

-- Debuggers
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb',
  name = 'lldb'
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
    program = function()
      local program = vim.fn.input('Program to debug: ')
      return program
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

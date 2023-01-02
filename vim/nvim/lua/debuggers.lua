local dap = require('dap')

-- Debuggers
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb',
  name = 'lldb'
}

-- dap.adapters.dlv = {
--   type = 'executable',
--   command = vim.fn.expand('$GOPATH/bin/dlv'),
--   name = 'delve'
-- }

-- configurations
dap.configurations.zig = {
  {
    type = 'lldb';
    request = 'launch';
    name = "Launch file";
    program = function()
      local program = vim.fn.input('Program to debug: ')
      return program
    end,
  },
}

-- dap.configurations.go = {
--   {
--     type = 'dlv';
--     request = 'launch';
--     name = "Launch file";
--   },
-- }

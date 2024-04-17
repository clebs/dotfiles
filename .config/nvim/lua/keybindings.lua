vim.g.mapleader = ' '
local key = vim.keymap
local cmd = vim.cmd

-- Debugger settings
local dap = require('dap')
local dapui = require('dapui')
key.set('n', '<F5>', dap.continue, { silent = true })
key.set('n', '<F10>', dap.step_over, { silent = true })
key.set('n', '<F11>', dap.step_into, { silent = true })
key.set('n', '<F12>', dap.step_out, { silent = true })
key.set('n', '<Leader>b', dap.toggle_breakpoint, { desc = 'Set breakpoint', silent = true })
key.set('n', '<Leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
    { desc = 'Set conditional breakpoint', silent = true })
key.set('n', '<Leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
    { silent = true })
key.set('n', '<Leader>dr', dap.repl.open, { silent = true })
key.set('n', '<Leader>dl', ':lua require("dap").run_last()<CR>ngs', { silent = true })
key.set('n', '<Leader>u', dapui.toggle, { desc = 'Toggle debug UI', silent = true })
key.set('n', '<Leader>de', dapui.eval, { silent = true, desc = 'Evaluate expression' })

-- Nvimtree
key.set('n', '<C-n>', cmd.NvimTreeToggle, { noremap = true, desc = 'Toggle file tree' })
key.set('n', '<Leader>ft', cmd.NvimTreeFindFile, { noremap = true, desc = 'Find file in tree' })
-- Remap open link to a different key, default does not work with netrw disabled and remapping the same key does not work.
local openCmd = vim.fn.has('macunix') == 1 and 'open' or 'xdg-open'
key.set('n', 'gb', ':!' .. openCmd .. ' <cfile><CR>', { desc = 'Open with default OS app.', silent = true, remap = true })

-- Telescope
local builtin = require('telescope.builtin')
key.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
key.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
key.set('n', '<leader>fb', builtin.buffers, { desc = 'Show buffers' })
key.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
key.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Show diagnostics results' })
key.set('n', '<leader>fe', require('telescope').load_extension('emoji').emoji, { desc = 'Emoji picker' })
key.set('n', '<leader>fp', require('telescope').load_extension('project').project,
    { desc = 'Project picker' })

-- Harpoon
local harpoon = require('harpoon')
key.set('n', '<leader>ha', function() harpoon:list():append() end, { desc = 'Harpoon append file' })
key.set('n', '<leader>hl', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon list' })
key.set('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon go to 1' })
key.set('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon go to 2' })
key.set('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon go to 3' })
key.set('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon go to 4' })
key.set('n', '<leader>5', function() harpoon:list():select(5) end, { desc = 'Harpoon go to 5' })
key.set('n', '<leader>6', function() harpoon:list():select(6) end, { desc = 'Harpoon go to 6' })

-- LSP
key.set('n', '<leader>rn', vim.lsp.buf.rename, { noremap = true, desc = 'Rename symbol' })
key.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, desc = 'Go to definition' })
key.set('n', 'gp', vim.lsp.buf.implementation, { noremap = true, desc = 'Go to implementation' })
key.set('n', 'gr', vim.lsp.buf.references, { noremap = true, desc = 'References' })
key.set('n', '<leader>ga', vim.lsp.buf.code_action, { noremap = true, desc = 'Code actions' })
key.set('n', '<leader>o', cmd.SymbolsOutline, { desc = 'Code Outline' })
key.set('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
key.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover docs' })

-- Git
key.set('n', '<leader>gd', cmd.DiffviewOpen, { desc = 'Open Git Diff' })
key.set('n', '<leader>gc', cmd.DiffviewClose, { desc = 'Close Git Diff' })
key.set('n', '<leader>gh', function() cmd('DiffviewFileHistory %') end, { desc = 'Git File History' })
key.set('n', '<leader>gH', cmd.DiffviewFileHistory, { desc = 'Git Repo History' })
key.set('n', '<leader>gb', cmd.BlamerToggle, { desc = 'Git Blame' })

-- Zen
key.set('n', '<leader>z', function() require('zen-mode').toggle({ window = { width = .80 } }) end, { desc = 'Zen mode' })

-- Neorg
key.set('n', '<leader>ni', function() cmd('Neorg index') end, { desc = 'Neorg index' })
key.set('n', '<leader>nr', function() cmd('Neorg return') end, { desc = 'Neorg return' })

-- Glow Markdown buffer_hunks_preview
key.set('n', '<leader>m', cmd.Glow, { desc = 'Markdown Preview' })

-- Miscelaneous --
key.set('n', '<leader>y', '\"*y', { noremap = true, desc = 'Copy to system clipboard' })
key.set('v', '<leader>y', '\"*y', { noremap = true, desc = 'Copy to system clipboard' })
key.set('x', '<leader>p', '\'_dP', { noremap = true, desc = 'Paste without overwrite' })
key.set('n', '<leader>q', cmd.copen, { noremap = true, desc = 'Open Quickfix list' })
key.set('n', '<leader>Q', cmd.cclose, { noremap = true, desc = 'Close Quickfix list' })
key.set('n', '<C-h>', cmd.noh, { noremap = true, desc = 'Clear search highlight' })
key.set('n', '<leader>tc', function() cmd('cd %:p:h') end, { desc = 'cd to current buffer dir' })
key.set('n', '<leader>tp', function() cmd('cd -') end, { desc = 'cd to previous dir' })

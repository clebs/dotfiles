vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
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
key.set('n', '<Leader>du', dapui.toggle, { desc = 'Toggle debug UI', silent = true })
key.set('n', '<Leader>de', dapui.eval, { silent = true, desc = 'Evaluate expression' })

-- Nvimtree
key.set('n', '<C-n>', cmd.NvimTreeToggle, { noremap = true, desc = 'Toggle file tree' })
key.set('n', '<Leader>ft', cmd.NvimTreeFindFile, { noremap = true, desc = 'Find file in tree' })
-- Remap open link to a different key, default does not work with netrw disabled and remapping the same key does not work.
local openCmd = vim.fn.has('macunix') == 1 and 'open' or 'xdg-open'
key.set('n', 'gb', ':!' .. openCmd .. ' <cfile><CR>', { desc = 'Open with default OS app.', silent = true, remap = true })

-- fzf-lua
local fzf = require('fzf-lua')
key.set('n', '<leader>ff', fzf.global, { desc = 'Find anything' })
-- live_grep: default regex, can switch to fuzzy
-- grewp_project: default fuzzy (slower), can switch to regex
key.set('n', '<leader>fg', fzf.live_grep, { desc = 'Live grep' })
key.set('n', '<leader>fb', fzf.buffers, { desc = 'Show buffers' })
key.set('n', '<leader>fh', fzf.help_tags, { desc = 'Help tags' })
key.set('n', '<leader>fd', fzf.diagnostics_document, { desc = 'Show file diagnostics' })
key.set('n', '<leader>fD', fzf.diagnostics_workspace, { desc = 'Show all diagnostics' })
key.set('n', '<leader>fr', fzf.lsp_references, { desc = 'Show References' })
key.set('n', '<leader>fp', fzf.lsp_implementations, { desc = 'Show Implementations' })
key.set('n', '<leader>fo', fzf.oldfiles, { desc = 'Recent files' })

-- Harpoon
local harpoon = require('harpoon')
key.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = 'Harpoon append file' })
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
key.set('n', 'gD', vim.lsp.buf.type_definition, { noremap = true, desc = 'Type definition' })
key.set('n', 'gp', vim.lsp.buf.implementation, { noremap = true, desc = 'Go to implementation' })
key.set('n', 'gr', vim.lsp.buf.references, { noremap = true, desc = 'References' })
key.set('n', '<leader>ga', vim.lsp.buf.code_action, { noremap = true, desc = 'Code actions' })
key.set('n', '<leader>o', cmd.Outline, { desc = 'Code Outline' })
key.set('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
key.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover docs' })

-- Git
key.set('n', '<leader>gd', cmd.DiffviewOpen, { desc = 'Open Git Diff' })
key.set('n', '<leader>gc', cmd.DiffviewClose, { desc = 'Close Git Diff' })
key.set('n', '<leader>gh', function() cmd('DiffviewFileHistory %') end, { desc = 'Git File History' })
key.set('n', '<leader>gH', cmd.DiffviewFileHistory, { desc = 'Git Repo History' })
key.set('n', '<leader>gb', cmd.BlamerToggle, { desc = 'Git Blame' })
key.set({ 'n', 'v' }, '<leader>gl',
    function()
        require("gitlinker").link({ action = require("gitlinker.actions").system })
    end,
    { desc = 'Git Browse' })

-- Zen
key.set('n', '<leader>z', function() require('zen-mode').toggle({ window = { width = .80 } }) end, { desc = 'Zen mode' })

-- Window and pane nav
key.set({ 'n', 'v' }, '<C-S-Left>', '<C-w>h', { noremap = true, silent = true })
key.set({ 'n', 'v' }, '<C-S-Right>', '<C-w>l', { noremap = true, silent = true })
key.set({ 'n', 'v' }, '<C-S-Up>', '<C-w>k', { noremap = true, silent = true })
key.set({ 'n', 'v' }, '<C-S-Down>', '<C-w>j', { noremap = true, silent = true })

-- Notes
key.set('n', '<leader>ni', function()
    cmd('tabnew')
    cmd('cd ~/Documents/notes')
    cmd('e index.md')
    cmd('NvimTreeRefresh')
end, { desc = 'Notes' })

key.set('n', '<leader>nr', function()
    cmd('tabclose')
    cmd('cd -')
    cmd('NvimTreeRefresh')
end, { desc = 'Notes return' })

-- Markdown preview in split pane
key.set('n', '<leader>m', ':Markview splitToggle <CR>', { desc = 'Markdown Preview' })

-- Miscelaneous --
key.set('n', '<leader>y', '\"*y', { noremap = true, desc = 'Copy to system clipboard' })
key.set('v', '<leader>y', '\"*y', { noremap = true, desc = 'Copy to system clipboard' })
key.set('x', '<leader>p', '\'_dP', { noremap = true, desc = 'Paste without overwrite' })
key.set('n', '<leader>q', cmd.copen, { noremap = true, desc = 'Open Quickfix list' })
key.set('n', '<leader>Q', cmd.cclose, { noremap = true, desc = 'Close Quickfix list' })
key.set('n', '<C-h>', cmd.noh, { noremap = true, desc = 'Clear search highlight' })
key.set('n', '<leader>tc', function() cmd('cd %:p:h') end, { desc = 'cd to current buffer dir' })
key.set('n', '<leader>tp', function() cmd('cd -') end, { desc = 'cd to previous dir' })

vim.g.mapleader = ' '

-- Functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Debugger settings 
map("n", "<F5>", ":lua require('dap').continue()<CR>", {silent = true})
map("n", "<F10>", ":lua require('dap').step_over()<CR>", {silent = true})
map("n", "<F11>", ":lua require('dap').step_into()<CR>", {silent = true})
map("n", "<F12>", ":lua require('dap').step_out()<CR>", {silent = true})
map("n", "<Leader>b", ":lua require('dap').toggle_breakpoint()<CR>", { silent = true })
map("n", "<Leader>B", ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", {silent = true})
map("n", "<Leader>lp", ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", {silent = true})
map("n", "<Leader>dr", ":lua require('dap').repl.open()<CR>", {silent = true})
map("n", "<Leader>dl", ":lua require('dap').run_last()<CR>ngs", {silent = true})

map('n', "<Leader>u", ":lua require('dapui').toggle()<CR>", {silent = true})

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

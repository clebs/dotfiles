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

-- LSP
map("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", { noremap = true })

-- GIT
map('n', '<C-k>', ":lua require('vgit').hunk_up()<CR>", {})
map('n', '<C-j>', ":lua require('vgit').hunk_down()<CR>", {})
map('n', '<leader>gs', ":lua require('vgit').buffer_hunk_stage()<CR>", {})
map('n', '<leader>gr', ":lua require('vgit').buffer_hunk_reset()<CR>", {})
map('n', '<leader>gp', ":lua require('vgit').buffer_hunk_preview()<CR>", {})
map('n', '<leader>gb', ":lua require('vgit').buffer_blame_preview()<CR>", {})
map('n', '<leader>gf', ":lua require('vgit').buffer_diff_preview()<CR>", {})
map('n', '<leader>gh', ":lua require('vgit').buffer_history_preview()<CR>", {})
map('n', '<leader>gu', ":lua require('vgit').buffer_reset()<CR>", {})
map('n', '<leader>gg', ":lua require('vgit').buffer_gutter_blame_preview()<CR>", {})
map('n', '<leader>glu', ":lua require('vgit').buffer_hunks_preview()<CR>", {})
map('n', '<leader>gls', ":lua require('vgit').project_hunks_staged_preview()<CR>", {})
map('n', '<leader>gd', ":lua require('vgit').project_diff_preview()<CR>", {})
map('n', '<leader>gq', ":lua require('vgit').project_hunks_qf()<CR>", {})
map('n', '<leader>gx', ":lua require('vgit').toggle_diff_preference()<CR>", {})
map('n', '<leader>go', ":lua require('vgit').project_logs_preview()<CR>", {})
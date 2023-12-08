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
map("n", "<F5>", ":lua require('dap').continue()<CR>", { silent = true })
map("n", "<F10>", ":lua require('dap').step_over()<CR>", { silent = true })
map("n", "<F11>", ":lua require('dap').step_into()<CR>", { silent = true })
map("n", "<F12>", ":lua require('dap').step_out()<CR>", { silent = true })
map("n", "<Leader>b", ":lua require('dap').toggle_breakpoint()<CR>", { silent = true })
map("n", "<Leader>B", ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { silent = true })
map("n", "<Leader>lp", ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
    { silent = true })
map("n", "<Leader>dr", ":lua require('dap').repl.open()<CR>", { silent = true })
map("n", "<Leader>dl", ":lua require('dap').run_last()<CR>ngs", { silent = true })
map('n', "<Leader>u", ":lua require('dapui').toggle()<CR>", { silent = true })
map("n", "<Leader>de", ":lua require('dapui').eval()<CR>", { silent = true, desc = "Evaluate expression" })

-- Nvimtree
vim.keymap.set('n', '<C-n>', vim.cmd.NvimTreeToggle, { noremap = true, desc = "Toggle file tree" })
vim.keymap.set('n', '<Leader>ft', vim.cmd.NvimTreeFindFile, { noremap = true, desc = "Find file in tree" })

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Show buffers" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help tags" })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = "Show diagnostics results" })
map("n", "<leader>fe", ":lua require('telescope').load_extension('emoji').emoji()<CR>", { desc = "Emoji picker" })
map("n", "<leader>fp", ":lua require('telescope').load_extension('project').project()<CR>", { desc = "Project picker" })

-- Harpoon
local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end, { desc = "Harpoon append file" })
vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon list" })
vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon go to 1" })
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon go to 2" })
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon go to 3" })
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon go to 4" })

-- LSP
map("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", { noremap = true, desc = "Rename symbol" })
map('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', { noremap = true, desc = "Go to definition" })
map('n', 'gp', ':lua vim.lsp.buf.implementation()<CR>', { noremap = true, desc = "Go to implementation" })
map('n', 'gr', ':lua vim.lsp.buf.references()<CR>', { noremap = true, desc = "References" })
map('n', '<leader>ga', ':lua vim.lsp.buf.code_action()<CR>', { noremap = true, desc = "Code actions" })
vim.keymap.set('n', '<leader>o', vim.cmd.SymbolsOutline, { desc = "Code Outline" })
vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- Git
map('n', '<leader>gd', ":lua vim.cmd('DiffviewOpen')<CR>", { desc = "Open Git Diff" })
map('n', '<leader>gc', ":lua vim.cmd('DiffviewClose')<CR>", { desc = "Close Git Diff" })
map('n', '<leader>gh', ":lua vim.cmd('DiffviewFileHistory %')<CR>", { desc = "Git File History" })
map('n', '<leader>gH', ":lua vim.cmd('DiffviewFileHistory')<CR>", { desc = "Git Repo History" })
map('n', '<leader>gb', ":lua vim.cmd('BlamerToggle')<CR>", { desc = "Git Blame" })

-- Zen
map('n', '<leader>z', ":lua require('zen-mode').toggle({window = {width = .80}})<CR>", { desc = "Zen mode" })

-- Glow Markdown buffer_hunks_preview
vim.keymap.set('n', '<leader>m', vim.cmd.Glow, { desc = "Markdown Preview" })

-- Miscelaneous --
map("n", "<leader>y", "\"*y", { noremap = true, desc = "Copy to system clipboard" })
map("v", "<leader>y", "\"*y", { noremap = true, desc = "Copy to system clipboard" })
map("x", "<leader>p", "\"_dP", { noremap = true, desc = "Paste without overwrite" })
map("n", "<leader>q", ":lua vim.cmd('copen')<CR>", { noremap = true, desc = "Open Quickfix list" })
map("n", "<leader>Q", ":lua vim.cmd('cclose')<CR>", { noremap = true, desc = "Close Quickfix list" })
map("n", "<C-h>", ":lua vim.cmd('noh')<CR>", { noremap = true, desc = "Clear search highlight" })

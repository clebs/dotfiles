local cmd = vim.cmd

-- Transparent BG
-- Focused pane/window
cmd('autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE')
-- All other panes and overlays
cmd('autocmd ColorScheme * highlight NormalNC ctermbg=NONE guibg=NONE')
cmd('autocmd ColorScheme * highlight NormalSB ctermbg=NONE guibg=NONE')

cmd.colorscheme("catppuccin-frappe")

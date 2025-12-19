vim.api.nvim_set_hl(0, "@comment.bonfire", { bg = "#26b5a0", fg = "#2e2e2e" })
vim.api.nvim_set_hl(0, "@comment.bug", { bg = "#c23a1b", fg = "#f2ba13" })
vim.api.nvim_set_hl(0, "@comment.note", { bg = "#3069b8", fg = "#52bf26" })
vim.api.nvim_set_hl(0, "@comment.fixme", { bg = "#dbd827", fg = "#1f1f1f" })
vim.api.nvim_set_hl(0, "@comment.xxx", { bg = "#53256e", fg = "#3073e6" })

require 'nvim-treesitter'.install {
  -- Minimal parsers
  "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "go", "zig", "comment", "bash",
  "json", "nix", "yaml"
}

local filetypes = { "c", "lua", "vim", "vimdoc", "md", "go", "zig", "sh", "json", "nix", "yaml" }

vim.api.nvim_create_autocmd('Filetype', {
  pattern = filetypes,
  callback = function() vim.treesitter.start() end,
})

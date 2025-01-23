vim.api.nvim_set_hl(0, "@comment.bonfire", { bg = "#26b5a0", fg = "#2e2e2e" })

require 'nvim-treesitter.configs'.setup {
  -- Minimal parsers
  ensure_installed = {
    "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "go", "zig", "comment", "bash",
    "json", "nix", "yaml"
  },
  -- Ensure highlighting is enabled
  highlight = {
    enable = true,                             -- Enable Tree-sitter-based syntax highlighting
    additional_vim_regex_highlighting = false, -- Disable standard regex-based syntax highlighting
  },
}

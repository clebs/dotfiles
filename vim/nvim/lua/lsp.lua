local lsp = require('lsp-zero')

lsp.set_preferences({
  float_border = 'rounded',
  suggest_lsp_servers = true,
  setup_servers_on_start = true,
  set_lsp_keymaps = true,
  configure_diagnostics = true,
  cmp_capabilities = true,
  manage_nvim_cmp = true,
  call_servers = 'local',
  sign_icons = {
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = ''
  }
})
lsp.setup()

-- Show text inline
vim.diagnostic.config({
  virtual_text = true,
})

-- Icons for autocomplete popup
local lspkind = require('lspkind')
require('cmp').setup {
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text', -- show only symbol annotations
      before = function(entry, vim_item)
        return vim_item
      end
    })
  }
}

vim.cmd('autocmd BufWritePre * lua vim.lsp.buf.format()')
vim.cmd(
  'autocmd BufWritePre *.go silent lua vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })'
)

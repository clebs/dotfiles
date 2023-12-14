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
local cmp = require('cmp')
cmp.setup {
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text', -- show only symbol annotations
      before = function(entry, vim_item)
        return vim_item
      end
    })
  },
  -- Always start autocomplete list at the top
  preselect = cmp.PreselectMode.None,
}

-- Swift LSP (not available on Mason)
local swift_lsp = vim.api.nvim_create_augroup("swift_lsp", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "swift" },
  callback = function()
    local root_dir = vim.fs.dirname(vim.fs.find({
      "Package.swift",
      ".git",
    }, { upward = true })[1])
    local client = vim.lsp.start({
      name = "sourcekit-lsp",
      cmd = { "sourcekit-lsp" },
      root_dir = root_dir,
    })
    vim.lsp.buf_attach_client(0, client)
  end,
  group = swift_lsp,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    vim.lsp.buf.format()
  end
})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
    vim.cmd('write')
  end
})

-- vars
lsp = vim.lsp
api = vim.api

-- Override globally
local orig_util_open_floating_preview = lsp.util.open_floating_preview
function lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Mason managed LSPs
local capabilities = require('cmp_nvim_lsp').default_capabilities(lsp.protocol.make_client_capabilities())

require('mason-lspconfig').setup()

-- Custom commands
api.nvim_create_user_command('LspStart', function()
  local ft = vim.bo.filetype

  for _, name in ipairs(vim.tbl_keys(lsp.config._configs or {})) do
    local conf = lsp.config[name]
    if conf and conf.filetypes and vim.tbl_contains(conf.filetypes, ft) then
      lsp.enable(name, true)
      return
    end
  end
end, {})


api.nvim_create_user_command('LspStop', function()
  local clients = lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    lsp.enable(client.name, false)
  end
end, {})

-- Custom handlers

-- Gopls
lsp.config('gopls', {
  settings = {
    ['gopls'] = {
      buildFlags = { '-tags=e2e' },
      completeUnimported = true,
      usePlaceholders = true,
      staticcheck = true,
      gofumpt = true,
    }
  },
  capabilities = capabilities,
})

-- organize imports on save
api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    lsp.buf.format({ async = false })
  end
})


-- Groovy
lsp.config('groovyls', {
  -- Unix
  cmd = { 'java', '-jar', vim.fn.stdpath('data') .. '/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar' },
  capabilities = capabilities,
})



-- Swift LSP (not available on Mason)
local swift_lsp = api.nvim_create_augroup("swift_lsp", { clear = true })
api.nvim_create_autocmd("FileType", {
  pattern = { "swift" },
  callback = function()
    local root_dir = vim.fs.dirname(vim.fs.find({
      "Package.swift",
      ".git",
    }, { upward = true })[1])
    local client = lsp.start({
      name = "sourcekit-lsp",
      cmd = { "sourcekit-lsp" },
      root_dir = root_dir,
    })
    lsp.buf_attach_client(0, client)
  end,
  group = swift_lsp,
})

api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = "silent! lua lsp.buf.format()",
})

-- UI

-- Override globally
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Mason managed LSPs
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require('mason-lspconfig').setup()
require('mason-lspconfig').setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
    }
  end,

  -- Next, you can provide a dedicated handler for specific servers.
  ['gopls'] = function()
    require('lspconfig').gopls.setup {
      settings = { gopls = {
        buildFlags = { '-tags=e2e,mage' },
        completeUnimported = true,
        usePlaceholders = true,
        staticcheck = true,
        gofumpt = true,
      } },
      capabilities = capabilities,
    }
  end,

  ['groovyls'] = function()
    require('lspconfig').groovyls.setup {
      -- Unix
      cmd = { 'java', '-jar', vim.fn.stdpath('data') .. '/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar' },
      capabilities = capabilities,
    }
  end
}

-- Extra config

-- Go: format and organize imports on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    local orignal = vim.notify
    vim.notify = function(msg, level, opts)
      if msg == 'No code actions available' then
        return
      end
      orignal(msg, level, opts)
    end

    vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
    vim.cmd('write')
  end
})


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
  command = "silent! lua vim.lsp.buf.format()",
})

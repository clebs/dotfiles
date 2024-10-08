-- Icons for autocomplete popup
local lspkind = require('lspkind')
local cmp = require('cmp')
local selectBehavior = { behavior = cmp.SelectBehavior, count = 1 }
cmp.setup {
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-n>'] = cmp.mapping.select_next_item(selectBehavior),
    ['<Tab>'] = cmp.mapping.select_next_item(selectBehavior),
    ['<C-p>'] = cmp.mapping.select_prev_item(selectBehavior),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(selectBehavior),
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
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
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

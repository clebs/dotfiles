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
    ['<C-l>'] = cmp.mapping.complete(),
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

  experimental = {
    ghost_text = true,
  },

  -- Always start autocomplete list at the top
  preselect = cmp.PreselectMode.None,
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'snippets' },
  },

  snippet = {
    expand = function(arg)
      vim.snippet.expand(arg.body)
    end,
  },

  sorting = {
    priority_weight = 1.0,
    comparators = {
      cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.order,
      cmp.config.compare.recently_used,
      cmp.config.compare.offset,
    },
  }
}

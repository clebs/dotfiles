-- Icons for autocomplete popup
local lspkind = require('lspkind')
local cmp = require('cmp')
local snip = vim.snippet
local selectBehavior = { behavior = cmp.SelectBehavior, count = 1 }
cmp.setup {
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(selectBehavior),
    ['<C-p>'] = cmp.mapping.select_prev_item(selectBehavior),
    ['<C-l>'] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),

    -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if snip.active() then
          snip.expand()
        else
          cmp.confirm({
            select = true,
          })
        end
      else
        fallback()
      end
    end),

    -- ['<Tab>'] = cmp.mapping.select_next_item(selectBehavior),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item(selectBehavior)
      elseif snip.active() then
        snip.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),

    -- ['<S-Tab>'] = cmp.mapping.select_prev_item(selectBehavior),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif snip.active() then
        snip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
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
      snip.expand(arg.body)
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

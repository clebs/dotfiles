-- Init snippets support and create a new completion source
local cmp = require("cmp")

-- Add the snippet folder to sources to load all files
package.path = vim.fn.stdpath('config') .. "/lua/snippets/?.lua;" .. package.path


local allSnips = require("go")

-- Define a custom source
local function snippets_source()
  return {
    complete = function(self, params, callback)
      local items = {}

      for _, snippet in ipairs(allSnips) do
        table.insert(items, {
          label = snippet.trigger,
          kind = cmp.lsp.CompletionItemKind.Snippet,
          documentation = snippet.description or "Snippet",
          insertText = snippet.body,
          insertTextFormat = cmp.lsp.InsertTextFormat.Snippet,
        })
      end

      callback({ items = items, isIncomplete = false })
    end,
  }
end

-- Register the custom source
cmp.register_source("snippets", snippets_source())

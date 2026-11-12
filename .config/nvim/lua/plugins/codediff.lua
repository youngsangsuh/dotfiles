-- codediff.nvim: VS Code-style side-by-side diffs and git history.
-- Useful for reviewing a large set of agent-made changes.
-- First use downloads the plugin's prebuilt diff library (:CodeDiff install).
vim.pack.add({
  { src = 'https://github.com/esmuellert/codediff.nvim' },
})

require('codediff').setup({
  explorer = {
    view_mode = 'tree',          -- directory tree instead of a flat list
    width = 50,
    auto_open_on_cursor = true,  -- j/k in the explorer also opens the file
    line_stats = { enabled = true }, -- +/- line counts per file
  },
  diff = {
    compact = true,              -- only changes + context, the rest folded (toggle: gc)
    compact_context_lines = 8,
    compact_sync_folds = true,   -- opening/closing a fold mirrors in the other pane
  },
})

local lifecycle = require('codediff.ui.lifecycle')
local mapKey = require('utils.keyMapper').mapKey

-- toggle: close the diff if we're in it, jump to an open one, or open a new one
mapKey('<leader>dv', function()
  local cur = vim.api.nvim_get_current_tabpage()
  if lifecycle.get_session(cur) then
    return lifecycle.close(cur)
  end
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    if lifecycle.get_session(tab) then
      return vim.api.nvim_set_current_tabpage(tab)
    end
  end
  vim.cmd('CodeDiff')
end)
mapKey('<leader>dh', '<cmd>CodeDiff history %<CR>') -- current file's history
mapKey('<leader>dH', '<cmd>CodeDiff history<CR>')   -- repo history

-- mini.diff (craftzdog fork, feat/grouping): inline diff overlay that groups
-- changes into whole hunks, the way `git diff` shows them.
-- gitsigns still owns the sign column and staging; mini.diff is used for the overlay.
vim.pack.add({
  { src = 'https://github.com/craftzdog/mini.diff', version = 'feat/grouping' },
})

local diff = require('mini.diff')

diff.setup({
  view = {
    style = 'number',      -- color line numbers; 'sign' would cover gitsigns' signs
    overlay_style = 'hunk', -- the fork's feature: whole hunks, like `git diff`
  },
  -- only the keys below; gitsigns handles staging/reverting
  mappings = {
    apply = '', reset = '', textobject = '',
    goto_first = '', goto_prev = '', goto_next = '', goto_last = '',
  },
})

local mapKey = require('utils.keyMapper').mapKey

mapKey('<leader>gd', function() diff.toggle_overlay(0) end) -- toggle the overlay

-- ]c / [c: jump between hunks; inside Vim's diff mode keep the built-in behavior
mapKey(']c', function()
  if vim.wo.diff then return vim.cmd('normal! ' .. vim.v.count1 .. ']c') end
  diff.goto_hunk('next', { n_times = vim.v.count1 })
end)
mapKey('[c', function()
  if vim.wo.diff then return vim.cmd('normal! ' .. vim.v.count1 .. '[c') end
  diff.goto_hunk('prev', { n_times = vim.v.count1 })
end)

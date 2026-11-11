-- snacks.nvim: picker, notifier, LSP word highlights, LSP-aware file renames
vim.pack.add({
  { src = 'https://github.com/folke/snacks.nvim' },
})

require('snacks').setup({
  picker = { enabled = true },
  notifier = { enabled = true }, -- vim.notify popups + history (;n)
  words = { enabled = true },    -- highlight LSP references of the word under cursor
  scroll = { enabled = false },  -- no smooth scroll: scrolling stays instant
})

local mapKey = require('utils.keyMapper').mapKey

-- pickers
mapKey(';f', function() Snacks.picker.files({ hidden = true }) end)  -- files, incl. dotfiles
mapKey(';r', function() Snacks.picker.grep({ hidden = true }) end)   -- live grep, incl. dotfiles
mapKey(';;', function() Snacks.picker.resume() end)                  -- reopen last picker
mapKey('\\\\', function()                                            -- open buffers
  Snacks.picker.buffers({ jump = { reuse_win = true } })             -- jump to a window already showing it
end)
mapKey(';e', function() Snacks.picker.diagnostics() end)             -- diagnostics
mapKey(';n', function() Snacks.picker.notifications() end)           -- notification history
mapKey(';h', function() Snacks.picker.git_diff() end)                -- git hunks

-- words: jump between LSP references of the word under cursor
mapKey(']]', function() Snacks.words.jump(vim.v.count1) end)
mapKey('[[', function() Snacks.words.jump(-vim.v.count1) end)

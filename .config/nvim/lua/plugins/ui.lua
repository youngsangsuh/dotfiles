-- tiny-cmdline: the `:` cmdline as a floating box, centered horizontally,
-- 20% from the top (with cmdheight=0 the eyes are already near the top).
-- Requires ui2, enabled at the end of config/options.lua.
vim.pack.add({
  { src = 'https://github.com/rachartier/tiny-cmdline.nvim' },
})

require('tiny-cmdline').setup({
  position = {
    x = '50%',
    y = '20%',
  },
})

-- mini.pairs: auto-close brackets/quotes. Defaults, plus command mode.
vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.pairs' },
})

require('mini.pairs').setup({
  modes = { insert = true, command = true, terminal = false },
})

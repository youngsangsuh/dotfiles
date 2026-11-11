-- Pinned to v1: v2 (main, from 2026-11-16) needs a config migration,
-- see https://github.com/petertriho/nvim-scrollbar/issues/121
vim.g.scrollbar_v2_notice = false

vim.pack.add({
  { src = 'https://github.com/kevinhwang91/nvim-hlslens' },
  { src = 'https://github.com/petertriho/nvim-scrollbar', version = 'v1' },
})

require("scrollbar").setup({
  handlers = {
    gitsigns = true,
    search = true,
  },
})

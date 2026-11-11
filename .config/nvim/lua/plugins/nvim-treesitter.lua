-- 'master' keeps the nvim-treesitter.configs API used below.
vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'master' },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "cpp", "cuda", "python", "rust", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
})

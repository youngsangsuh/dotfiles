local mapKey = require("utils.keyMapper").mapKey

vim.pack.add({
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim', version = '0.1.8' },
})

require("telescope").setup({
  pickers = {
    -- include dotfiles (rg skips hidden files by default), but never .git/
    find_files = {
      hidden = true,
      file_ignore_patterns = { "^%.git/" },
    },
    live_grep = {
      additional_args = { "--hidden", "--glob", "!.git" },
    },
  },
})

local builtin = require("telescope.builtin")
mapKey('<leader>ff', builtin.find_files)
mapKey('<leader>fg', builtin.live_grep)
mapKey('<leader>fb', builtin.buffers)
mapKey('<leader>fh', builtin.help_tags)

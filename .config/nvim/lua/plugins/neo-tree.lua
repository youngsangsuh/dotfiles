vim.pack.add({
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/MunifTanjim/nui.nvim' },
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = 'v3.x' },
})

require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      visible = true,
    },
    follow_current_file = {
      enabled = true,   -- automatically reveal the file
      leave_dirs_open = true,
    },
  },
})

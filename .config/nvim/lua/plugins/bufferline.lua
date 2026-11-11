vim.pack.add({
  { src = 'https://github.com/akinsho/bufferline.nvim', version = vim.version.range('*') },
})

require("bufferline").setup {
  options = {
    mode = 'buffers',
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true,
      }
    }
  }
}

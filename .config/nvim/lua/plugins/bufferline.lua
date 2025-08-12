return {
  'akinsho/bufferline.nvim',
  version = "*",
  config = function()
    vim.opt.termguicolors = true
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
  end,
}

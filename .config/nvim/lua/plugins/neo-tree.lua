vim.pack.add({
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/MunifTanjim/nui.nvim' },
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = 'v3.x' },
})

-- LSP-aware renames: tell language servers (willRename/didRename) so they can
-- update imports, `mod` declarations, etc. See utils/lsp_rename.lua.
local function on_move(data)
  require("utils.lsp_rename").on_rename_file(data.source, data.destination)
end
local events = require("neo-tree.events")

require("neo-tree").setup({
  event_handlers = {
    { event = events.FILE_MOVED, handler = on_move },
    { event = events.FILE_RENAMED, handler = on_move },
  },
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

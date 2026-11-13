-- snacks.nvim: picker, notifier, LSP word highlights, LSP-aware file renames
vim.pack.add({
  { src = "https://github.com/folke/snacks.nvim" },
})

require("snacks").setup({
  picker = { enabled = true },
  notifier = { enabled = true }, -- vim.notify popups + history (;n)
  words = { enabled = true }, -- highlight LSP references of the word under cursor
  scroll = { enabled = false }, -- no smooth scroll: scrolling stays instant
  lazygit = {
    -- only for lazygit opened from Neovim (written to snacks' generated config,
    -- which lazygit loads after ~/.config/lazygit/config.yaml)
    config = {
      os = { editInTerminal = false }, -- `e` talks to this Neovim; don't suspend
    },
    -- theme synced from the colorscheme; active border in the WarningMsg color
    theme = {
      activeBorderColor = { fg = "WarningMsg", bold = true },
    },
  },
})

-- lazygit's own config lives outside the Neovim config; snacks loads it plus its theme file
local lazygit_config = vim.fn.expand("~/.config/lazygit/config.yaml")
if vim.uv.fs_stat(lazygit_config) then
  vim.env.LG_CONFIG_FILE = lazygit_config
end

local mapKey = require("utils.keyMapper").mapKey

-- pickers

-- files, incl. dotfiles
mapKey(";f", function()
  Snacks.picker.files({ hidden = true })
end)

-- live grep, incl. dotfiles
mapKey(";r", function()
  Snacks.picker.grep({ hidden = true })
end)

-- reopen last picker
mapKey(";;", function()
  Snacks.picker.resume()
end)

-- open buffers; jump to a window already showing the buffer
mapKey("\\\\", function()
  Snacks.picker.buffers({ jump = { reuse_win = true } })
end)

-- diagnostics
mapKey(";e", function()
  Snacks.picker.diagnostics()
end)

-- notification history
mapKey(";n", function()
  Snacks.picker.notifications()
end)

-- git hunks
mapKey(";h", function()
  Snacks.picker.git_diff()
end)

-- lazygit (float)
mapKey(";g", function()
  require("utils.lazygit").open()
end)

-- words: jump between LSP references of the word under cursor
mapKey("]]", function()
  Snacks.words.jump(vim.v.count1)
end)
mapKey("[[", function()
  Snacks.words.jump(-vim.v.count1)
end)

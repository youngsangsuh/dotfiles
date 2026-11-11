-- leader must be set before any plugin/keymap is loaded
require("config.globals")
require("config.options")
require("config.keymaps")

-- plugins (managed by the built-in vim.pack)
require("plugins")

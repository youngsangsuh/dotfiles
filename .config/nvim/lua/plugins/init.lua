-- Plugin manager: native vim.pack (Neovim 0.12+)
--   :lua vim.pack.update()        update all plugins
--   :lua vim.pack.del({ 'name' }) remove a plugin
-- Versions are pinned in ../../nvim-pack-lock.json (commit it).

-- Build hooks must be registered before vim.pack.add() installs anything.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
  end,
})

-- Load order matters: colorscheme first, dependencies before dependents.
require("plugins.solarized-osaka")
require("plugins.nvim-web-devicons")
require("plugins.nvim-treesitter")
require("plugins.gitsigns")
require("plugins.nvim-scrollbar")
require("plugins.indent-blankline")
require("plugins.bufferline")
require("plugins.neo-tree")
require("plugins.telescope")
require("plugins.copilot")
require("plugins.ui")

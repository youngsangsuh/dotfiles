vim.pack.add({
  { src = 'https://github.com/craftzdog/solarized-osaka.nvim' },
})

require("solarized-osaka").setup({
  style = "vivid",  -- higher-contrast variant
  transparent = true, -- no background: the terminal's blur shows through
  styles = {
    sidebars = "transparent", -- neo-tree, etc.
    floats = "transparent",   -- telescope, popups
  },
})

vim.cmd.colorscheme("solarized-osaka")

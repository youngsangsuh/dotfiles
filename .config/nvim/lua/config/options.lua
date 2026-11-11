local opt = vim.opt

-- tab/indent
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false

-- search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- visual
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.background = "dark"

-- etc
opt.encoding = "UTF-8"
opt.cmdheight = 0 -- cmdline is a floating box (tiny-cmdline), messages via ui2
opt.scrolloff = 10
opt.mouse:append("a")
opt.clipboard = 'unnamedplus'
opt.cursorline = true
opt.cursorcolumn = true

-- ui2: Neovim 0.12's experimental message/cmdline UI (see :h ui2)
--   msg   = corner popup that disappears after the timeout
--   pager = scrollable window for long output
--   cmd   = the command line itself (expands over the bottom until the next key;
--           <CR> moves it into the pager)
-- Lookup order: trigger first, then kind, then the default `target`.
require('vim._core.ui2').enable({
  msg = {
    target = 'msg', -- short messages: corner popup
    targets = {
      -- output of a command I typed stays in the cmdline, whatever its kind
      typed_cmd = 'cmd',

      -- long output: pager
      emsg = 'pager',
      echoerr = 'pager',
      lua_error = 'pager',
      rpc_error = 'pager',
      list_cmd = 'pager',   -- :ls, :set, ...
      verbose = 'pager',
      shell_cmd = 'pager',
      shell_out = 'pager',
      shell_err = 'pager',
      shell_ret = 'pager',
      progress = 'pager',

      -- stay in the cmdline
      search_cmd = 'cmd',
      search_count = 'cmd',
      completion = 'cmd',
      wildlist = 'cmd',
      confirm = 'cmd',
    },
    msg = { height = 0.3, timeout = 5000 }, -- popup: max 30% tall, 5s
    pager = { height = 0.5 },               -- pager: max half the screen
  },
})

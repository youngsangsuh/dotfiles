local mapKey = require("utils.keyMapper").mapKey

-- Neotree toggle
mapKey('<leader>e', ':Neotree toggle<cr>')

-- pane navigation
mapKey('<C-h>', '<C-w>h') -- Left
mapKey('<C-j>', '<C-w>j') -- Down
mapKey('<C-k>', '<C-w>k') -- Up
mapKey('<C-l>', '<C-w>l') -- Right

mapKey('<leader>,', '<C-w>h') -- Left
mapKey('<leader>.', '<C-w>l') -- Right

-- tabs
mapKey('te', ':tabedit<CR>')       -- new tab
mapKey('<Tab>', ':tabnext<CR>')    -- next tab
mapKey('<S-Tab>', ':tabprev<CR>')  -- previous tab

-- splits
mapKey('ss', ':split<CR>')   -- horizontal split
mapKey('sv', ':vsplit<CR>')  -- vertical split

-- window navigation (home row)
mapKey('sh', '<C-w>h') -- Left
mapKey('sj', '<C-w>j') -- Down
mapKey('sk', '<C-w>k') -- Up
mapKey('sl', '<C-w>l') -- Right

-- clear search hl
mapKey('<leader>h', ':nohlsearch<CR>')

-- indent
mapKey('<', '<gv', 'v')
mapKey('>', '>gv', 'v')

-- bufferline
mapKey('<leader>bl', ':BufferLinePick<CR>')

-- custom
mapKey('<C-v>', '<Esc><C-v>', 'i')
mapKey('d', '"_d', 'v')

-- delete/change/paste without touching the yank register ("_ = black hole)
mapKey('x', '"_x')                         -- delete char without copying
mapKey('<leader>d', '"_d', { 'n', 'v' })   -- delete (e.g. <leader>dd, <leader>dw)
mapKey('<leader>c', '"_c', { 'n', 'v' })   -- change (e.g. <leader>cw)
mapKey('<leader>p', '"_dP', 'x')           -- paste over selection, keep yank

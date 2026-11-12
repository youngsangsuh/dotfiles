-- lualine: one global statusline.
--   a: mode | b: git branch | c: [project root] icon path/file
--   x: recording @q, diagnostics, git diff | y: progress | z: line:column
vim.pack.add({
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
})

local root_markers = { '.git', 'lua', 'package.json', 'Makefile', 'Cargo.toml', 'go.mod', 'pyproject.toml' }

-- Nearest directory above the current buffer that contains any root marker
-- (falls back to cwd for unnamed/special buffers).
local function project_root()
  local name = vim.api.nvim_buf_get_name(0)
  if name == '' or vim.bo.buftype ~= '' then
    return vim.fn.getcwd()
  end
  -- nested list = equal priority, so the nearest marker wins (a flat list would
  -- search for '.git' all the way up before trying the next marker)
  return vim.fs.root(0, { root_markers }) or vim.fn.getcwd()
end

-- Root folder name, shown only when the root isn't the cwd.
local function root_name()
  local root = project_root()
  if vim.fs.normalize(root) == vim.fs.normalize(vim.fn.getcwd()) then
    return ''
  end
  return '󱉭 ' .. vim.fs.basename(root)
end

-- Directory part of the path, relative to the project root, shortened to the
-- last 3 folders. The filename itself is the next (bold) component.
local function path_dir()
  local name = vim.api.nvim_buf_get_name(0)
  if name == '' or vim.bo.buftype ~= '' then
    return ''
  end
  local root = project_root()
  local rel = vim.fs.relpath(root, name) or vim.fn.fnamemodify(name, ':~')
  local dir = vim.fs.dirname(rel)
  if dir == '.' then
    return ''
  end
  local parts = vim.split(dir, '/', { plain = true })
  if #parts > 3 then
    parts = { '…', unpack(parts, #parts - 2) }
  end
  return table.concat(parts, '/') .. '/'
end

-- Macro recording indicator (the cmdline is hidden with cmdheight=0).
local function recording()
  local reg = vim.fn.reg_recording()
  return reg ~= '' and ('recording @' .. reg) or ''
end

-- git diff counts straight from gitsigns (already computed, no extra git calls)
local function diff_source()
  local g = vim.b.gitsigns_status_dict
  if g then
    return { added = g.added, modified = g.changed, removed = g.removed }
  end
end

require('lualine').setup({
  options = {
    theme = 'auto',
    globalstatus = true, -- one bar for all windows (laststatus=3)
    -- default refresh events already include CursorMoved/CursorMovedI;
    -- macro start/stop is handled by the autocmd below
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = {
      { root_name, color = 'Special' },
      { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
      { path_dir, separator = '', padding = { left = 1, right = 0 } },
      { 'filename', path = 0, color = { gui = 'bold' }, padding = { left = 0, right = 1 } },
    },
    lualine_x = {
      { recording, color = 'WarningMsg' },
      'diagnostics',
      { 'diff', source = diff_source },
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})

-- Refresh when a macro starts/stops. On RecordingLeave reg_recording() still
-- returns the register, so refresh on the next tick.
vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
  group = vim.api.nvim_create_augroup('LualineRecording', { clear = true }),
  callback = function()
    vim.schedule(function() require('lualine').refresh() end)
  end,
})

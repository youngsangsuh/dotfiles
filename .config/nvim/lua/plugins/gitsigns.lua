vim.pack.add({
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup({
  signs = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signs_staged = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signs_staged_enable = true,
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 500,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
})

-- keymaps
local gs = require("gitsigns")
local mapKey = require("utils.keyMapper").mapKey

mapKey("<leader>gb", function()
  gs.blame_line()
end) -- blame the line (popup)
mapKey("<leader>gB", function()
  gs.blame()
end) -- blame the whole buffer
mapKey("<leader>gh", function()
  gs.stage_hunk()
end) -- stage hunk; on a staged hunk, unstage it

-- revert the hunk under the cursor to the index (discards the change; `u` undoes it)
mapKey("<leader>gr", function()
  gs.reset_hunk()
end)
-- visual: revert only the selected lines
mapKey("<leader>gr", function()
  gs.reset_hunk({ vim.fn.line("v"), vim.fn.line(".") })
end, "v")

-- stage the buffer; if nothing is left to stage, unstage it instead
mapKey("<leader>gs", function()
  local s = vim.b.gitsigns_status_dict or {}
  local unstaged = (s.added or 0) + (s.changed or 0) + (s.removed or 0)
  if unstaged > 0 then
    gs.stage_buffer()
  else
    gs.reset_buffer_index()
  end
end)

-- Where the current buffer's text comes from: repo root, revision (nil = working
-- tree) and repo-relative path. Handles real files, gitsigns:// buffers
-- (`<leader>gB`, :Gitsigns show) and the tabs opened by <leader>go itself.
local function buffer_source()
  if vim.b.git_source then
    return vim.b.git_source
  end
  local name = vim.api.nvim_buf_get_name(0)
  local gitdir, rest = name:match("^gitsigns://(.-)//(.+)$")
  if gitdir then
    -- rest is "<rev>:<path>", or ":<stage>:<path>" for the index
    local rev, path = rest:match("^(:%d):(.+)$")
    if not rev then
      rev, path = rest:match("^([^:]+):(.+)$")
    end
    if not path then
      return nil -- a commit view, not a file
    end
    local root = vim.trim(
      vim.system({ "git", "--git-dir", gitdir, "rev-parse", "--show-toplevel" }, { text = true }):wait().stdout
    )
    if root == "" then
      root = vim.fs.dirname(gitdir)
    end
    return { root = root, rev = rev, path = path }
  end
  if vim.bo.buftype ~= "" or vim.fn.filereadable(name) == 0 then
    return nil
  end
  local root = vim.trim(
    vim.system({ "git", "rev-parse", "--show-toplevel" }, { cwd = vim.fs.dirname(name), text = true }):wait().stdout
  )
  if root == "" then
    return nil
  end
  return { root = root, rev = nil, path = vim.fs.relpath(root, name) }
end

-- open the file as of the commit that last touched this line, in a new tab,
-- with the cursor on that line as it was in that commit
mapKey("<leader>go", function()
  local src = buffer_source()
  if not src then
    return vim.notify("Not a file tracked by git", vim.log.levels.INFO)
  end
  local lnum = vim.fn.line(".")
  local cmd = { "git", "blame", "--porcelain", "-L", lnum .. "," .. lnum }
  if src.rev then
    table.insert(cmd, src.rev)
  end
  vim.list_extend(cmd, { "--", src.path })
  local blame = vim.system(cmd, { cwd = src.root, text = true }):wait()
  if blame.code ~= 0 then
    return vim.notify("git blame failed: " .. vim.trim(blame.stderr), vim.log.levels.WARN)
  end
  local sha, orig_lnum = blame.stdout:match("^(%x+) (%d+)")
  if not sha or sha:match("^0+$") then
    return vim.notify("Line is not committed yet", vim.log.levels.INFO)
  end
  -- path at that commit (differs if the file was renamed since)
  local path = blame.stdout:match("\nfilename ([^\n]+)") or src.path
  local show = vim.system({ "git", "show", sha .. ":" .. path }, { cwd = src.root, text = true }):wait()
  if show.code ~= 0 then
    return vim.notify("git show failed: " .. vim.trim(show.stderr), vim.log.levels.WARN)
  end

  local ft = vim.bo.filetype
  vim.cmd.tabnew()
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split((show.stdout:gsub("\n$", "")), "\n", { plain = true }))
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = ft
  vim.b[buf].git_source = { root = src.root, rev = sha, path = path } -- lets <leader>go work in this tab too
  pcall(vim.api.nvim_buf_set_name, buf, sha:sub(1, 8) .. ":" .. path)
  vim.api.nvim_win_set_cursor(0, { tonumber(orig_lnum), 0 })
  vim.cmd("normal! zz")
end)

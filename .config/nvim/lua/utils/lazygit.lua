-- lazygit in a snacks.nvim float; `e` on a file opens it in the window
-- lazygit was launched from (see ~/.config/lazygit/config.yaml, os.edit).
local M = {}

---@type integer?
M.origin_win = nil

function M.open()
  M.origin_win = vim.api.nvim_get_current_win()
  Snacks.lazygit()
end

-- called by lazygit's edit command through `nvim --server $NVIM --remote-send`
function M.focus_origin()
  local win = M.origin_win
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
  end
end

return M

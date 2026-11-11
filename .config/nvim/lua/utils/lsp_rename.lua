-- Tell language servers about a file rename/move so they can update imports,
-- `mod` declarations, etc.
--   willRenameFiles: server returns edits, applied before the move (when the move
--                    hasn't happened yet; `rename` callback does it)
--   didRenameFiles:  notification after the move (vtsls updates imports here)
-- Written instead of Snacks.rename.on_rename_file, which uses `client.method()`
-- dot-calls that silently report "unsupported" on Neovim 0.12.
local M = {}

---@param from string
---@param to string
---@param rename? fun() performs the move (omit if it already happened)
function M.on_rename_file(from, to, rename)
  local changes = { files = { { oldUri = vim.uri_from_fname(from), newUri = vim.uri_from_fname(to) } } }
  local clients = vim.lsp.get_clients()

  for _, client in ipairs(clients) do
    if client:supports_method('workspace/willRenameFiles') then
      local resp = client:request_sync('workspace/willRenameFiles', changes, 5000, 0)
      if resp and resp.result then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end

  if rename then rename() end

  for _, client in ipairs(clients) do
    if client:supports_method('workspace/didRenameFiles') then
      client:notify('workspace/didRenameFiles', changes)
    end
  end
end

return M

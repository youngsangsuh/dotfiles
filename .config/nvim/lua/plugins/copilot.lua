-- Installed but not loaded at startup; loaded on first InsertEnter.
vim.pack.add({
  { src = 'https://github.com/github/copilot.vim' },
}, { load = function() end })

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function() vim.cmd.packadd("copilot.vim") end,
})

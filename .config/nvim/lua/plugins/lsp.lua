-- Language servers & formatters
--   mason.nvim                 installs the binaries (into stdpath('data')/mason, added to PATH)
--   mason-tool-installer.nvim  installs the list below on start; never auto-updates
--   nvim-lspconfig             supplies default server configs (cmd, filetypes, root markers)
--   vim.lsp.enable()           turns servers on (native, Neovim 0.11+)
vim.pack.add({
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
})

require('mason').setup()

require('mason-tool-installer').setup({
  ensure_installed = {
    -- servers
    'lua-language-server',
    'vtsls',
    'eslint-lsp',
    'oxlint',
    'tailwindcss-language-server',
    'css-lsp',
    'rust-analyzer',
    'copilot-language-server',
    'clangd',
    -- formatters
    'prettier',
    'prettierd',
    'oxfmt',
    'stylua',
    'shfmt',
    'clang-format',
  },
  run_on_start = true, -- install anything missing on startup
  auto_update = false, -- never upgrade installed tools; use :MasonToolsUpdate by hand
})

-- Every server: advertise file-rename support (workspace/didRenameFiles, willRenameFiles)
vim.lsp.config('*', {
  capabilities = {
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  },
})

-- vtsls: update imports when a file is moved/renamed (default "prompt" asks every time)
vim.lsp.config('vtsls', {
  settings = {
    typescript = { updateImportsOnFileMove = { enabled = 'always' } },
    javascript = { updateImportsOnFileMove = { enabled = 'always' } },
  },
})

vim.lsp.enable({
  'eslint',
  'oxlint',
  'lua_ls',
  'cssls',
  'vtsls',
  'tailwindcss',
  'rust_analyzer',
  'clangd', -- c, cpp, cuda (+ objc, objcpp)
})

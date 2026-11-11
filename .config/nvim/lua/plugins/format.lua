-- conform.nvim: run formatters on save, falling back to the LSP's formatter
-- when no formatter below is configured/available for the filetype.
--   :ConformInfo                   show which formatter will run for this buffer
--   :lua require('conform').format() format manually
vim.pack.add({
  { src = 'https://github.com/stevearc/conform.nvim' },
})

-- JS/TS-family: oxfmt in projects that configure it, otherwise prettierd -> prettier.
local web = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true }

require('conform').setup({
  formatters_by_ft = {
    -- C family: uses the nearest .clang-format above the file
    c = { 'clang-format' },
    cpp = { 'clang-format' },
    cuda = { 'clang-format' },

    lua = { 'stylua' },
    sh = { 'shfmt' },
    bash = { 'shfmt' },

    javascript = web,
    javascriptreact = web,
    typescript = web,
    typescriptreact = web,
    json = web,
    jsonc = web,
    css = web,
    scss = web,
    html = web,
    markdown = web,
    yaml = web,
  },

  formatters = {
    ['clang-format'] = {
      -- no .clang-format found -> leave the file alone instead of
      -- reformatting it in clang-format's built-in LLVM style
      prepend_args = { '--fallback-style=none' },
    },
    oxfmt = {
      -- only when the project has an oxfmt config; otherwise fall through to prettier
      condition = function(_, ctx)
        return vim.fs.find(
          { '.oxfmtrc.json', '.oxfmtrc.jsonc', 'oxfmt.config.ts' },
          { upward = true, path = ctx.dirname }
        )[1] ~= nil
      end,
    },
  },

  default_format_opts = { lsp_format = 'fallback' },
  format_on_save = { timeout_ms = 1000, lsp_format = 'fallback' },
})

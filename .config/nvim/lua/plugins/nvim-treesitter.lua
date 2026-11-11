-- nvim-treesitter `main` branch (the rewrite; `master` is frozen).
-- Parsers are rebuilt by the PackChanged -> :TSUpdate hook in plugins/init.lua,
-- so they stay in sync with the plugin version.
vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
})

local ensure_installed = {
  "astro", "bash", "c", "cmake", "cpp", "css", "cuda", "diff", "fish", "gitignore",
  "go", "graphql", "html", "http", "java", "javascript", "jsdoc", "json",
  "lua", "luadoc", "luap", "markdown", "markdown_inline", "php", "printf",
  "python", "query", "regex", "rust", "scss", "sql", "svelte", "toml", "tsx",
  "typescript", "vim", "vimdoc", "xml", "yaml",
}

-- Installs only what's missing (async, no-op when everything is present).
-- Needs the `tree-sitter` CLI on PATH (brew install tree-sitter-cli).
require("nvim-treesitter").install(ensure_installed)

-- Start highlighting + treesitter indent for any buffer whose parser exists.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang or not vim.treesitter.language.add(lang) then
      return
    end
    vim.treesitter.start(ev.buf, lang)
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

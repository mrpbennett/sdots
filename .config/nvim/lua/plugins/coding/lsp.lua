vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

require("mason").setup()

require("mason-tool-installer").setup({
  ensure_installed = {
    -- bash
    "bash-language-server",

    -- copilot
    "copilot-language-server",

    -- lua
    "lua-language-server",

    -- python
    "ty",
    "ruff",

    -- yaml
    "yaml-language-server",
    "yamllint",
    "yamlfmt",
  },
})


vim.lsp.enable({
  -- copilot
  "copilot-language-server",
  -- lua
  "lua_ls",

  -- python
  "ty",
  "ruff",

  -- yaml
  "yamlls",
})

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  opts = {
    ensure_installed = {
      "lua",
      "python",
      "rust",
      "c",
      "cpp",
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      "json",
      "jsonc",
      "yaml",
      "vim",
      "vimdoc",
    },
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
      disable = { "python", "rust" },
    },
  },
  config = function(_, opts)
    vim.treesitter.language.register("tsx", "javascriptreact")
    vim.treesitter.language.register("tsx", "typescriptreact")
    require("nvim-treesitter.configs").setup(opts)
  end,
}

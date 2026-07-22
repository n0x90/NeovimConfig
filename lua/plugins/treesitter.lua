return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "c",
      "cpp",
      "css",
      "html",
      "javascript",
      "json",
      "lua",
      "python",
      "query",
      "regex",
      "rust",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },
    auto_install = false,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
      disable = { "python", "rust" },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}

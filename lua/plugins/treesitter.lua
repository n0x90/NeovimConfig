return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,

  opts = {
    highlight = { enable = true },
    indent = { enable = false },
    auto_install = true,
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
  },

  config = function(_, opts)
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      return
    end

    pcall(vim.treesitter.language.register, "tsx", "javascriptreact")
    pcall(vim.treesitter.language.register, "tsx", "typescriptreact")

    configs.setup(opts)
  end,
}

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>f", group = "find" },
      { "<leader>c", group = "code" },
      { "<leader>r", group = "rename" },
      { "<leader>d", group = "debug" },
      { "<leader>t", group = "terminal" },
      { "<leader>b", group = "buffer" },
    },
  },
}
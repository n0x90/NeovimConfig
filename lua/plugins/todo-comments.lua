return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TodoTelescope", "TodoTrouble", "TodoQuickFix", "TodoLocList" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next todo comment",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous todo comment",
    },
    {
      "<leader>ft",
      "<cmd>TodoTelescope<cr>",
      desc = "Todo comments",
    },
    {
      "<leader>fT",
      "<cmd>TodoTelescope keywords=TODO,FIX,HACK,WARN,NOTE,PERF,TEST<cr>",
      desc = "Todo comments (all)",
    },
  },
  opts = {
    signs = true,
  },
}

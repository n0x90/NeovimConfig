return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
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
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Todo comments",
    },
    {
      "<leader>fT",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Todo comments (all)",
    },
  },
  opts = {
    signs = true,
  },
}

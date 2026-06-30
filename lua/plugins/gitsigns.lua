return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")

      vim.keymap.set("n", "]h", gs.next_hunk, { buffer = bufnr })
      vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = bufnr })
      vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr })
      vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr })
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr })
      vim.keymap.set("n", "<leader>hH", function()
        gs.show("HEAD")
      end, { buffer = bufnr, desc = "Open file from git HEAD" })
    end,
  },
}

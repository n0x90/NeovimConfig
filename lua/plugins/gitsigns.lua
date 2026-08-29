return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")

      vim.keymap.set("n", "]h", function()
        gs.nav_hunk("next")
      end, { buffer = bufnr, desc = "Next Git hunk" })
      vim.keymap.set("n", "[h", function()
        gs.nav_hunk("prev")
      end, { buffer = bufnr, desc = "Previous Git hunk" })
      vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr })
      vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr })
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr })
      vim.keymap.set("n", "<leader>hH", function()
        gs.show("HEAD")
      end, { buffer = bufnr, desc = "Open file from git HEAD" })
    end,
  },
}

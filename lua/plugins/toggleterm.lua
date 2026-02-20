return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    { "<leader>tt", desc = "Terminal (float)" },
    { "<leader>tb", desc = "Terminal (bottom)" },
  },
  opts = {
    direction = "float",
    start_in_insert = true,
    close_on_exit = true,
    shade_terminals = true,
    float_opts = {
      border = "rounded",
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local Terminal = require("toggleterm.terminal").Terminal

    local float = Terminal:new({
      direction = "float",
      hidden = true,
    })

    local bottom = Terminal:new({
      direction = "horizontal",
      size = 15,
      hidden = true,
    })

    vim.keymap.set("n", "<leader>tt", function() float:toggle() end, { desc = "Terminal (float)" })
    vim.keymap.set("n", "<leader>tb", function() bottom:toggle() end, { desc = "Terminal (bottom)" })

  end,
}
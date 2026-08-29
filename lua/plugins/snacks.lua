return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>fp", function() Snacks.picker.git_files() end, desc = "Find git files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
    { "<leader>fd", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer diagnostics" },
    { "<leader>fD", function() Snacks.picker.diagnostics() end, desc = "Workspace diagnostics" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
    { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
    { "<leader>fR", function() Snacks.picker.lsp_references() end, desc = "References" },
  },
  opts = {
    picker = {
      enabled = true,
      ui_select = true,
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    vim.ui.select = Snacks.picker.select
  end,
}

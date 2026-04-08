return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fp", "<cmd>Telescope git_files<cr>", desc = "Find git files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    {
      "<leader>fd",
      function()
        require("telescope.builtin").diagnostics({ bufnr = 0 })
      end,
      desc = "Buffer diagnostics",
    },
    {
      "<leader>fD",
      function()
        require("telescope.builtin").diagnostics()
      end,
      desc = "Workspace diagnostics",
    },
    {
      "<leader>fs",
      function()
        require("telescope.builtin").lsp_document_symbols()
      end,
      desc = "Document symbols",
    },
    {
      "<leader>fS",
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols()
      end,
      desc = "Workspace symbols",
    },
    {
      "<leader>fR",
      function()
        require("telescope.builtin").lsp_references()
      end,
      desc = "References",
    },
  },
  opts = {
    extensions = {
      ["ui-select"] = {},
      fzf = {},
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
  end,
}

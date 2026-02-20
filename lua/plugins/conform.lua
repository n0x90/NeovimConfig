return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  opts = {
    formatters = {
      ruff_format = {
        command = function(_)
          local cwd = vim.fn.getcwd()
          return cwd .. "/.venv/bin/ruff"
        end,
      },
    },
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      python = { "ruff_format" },
      rust = { "rustfmt" },
    },
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },
  },
}
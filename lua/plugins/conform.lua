return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  opts = {
    formatters_by_ft = {
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },

      python = { "ruff_format" },
      rust = { "rustfmt" },
    },

    format_on_save = function(_)
      return {
        timeout_ms = 500,
        lsp_format = "never",
      }
    end,
  },
}

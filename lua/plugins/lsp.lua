return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "pyright",
        "ruff",
        "rust_analyzer",
        "clangd",
        "html",
        "cssls",
        "tailwindcss",
        "eslint",
        "emmet_language_server",
        "ts_ls",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason-lspconfig.nvim",
    },
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, {
              buffer = args.buf,
              desc = desc,
            })
          end

          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gr", vim.lsp.buf.references, "Go to references")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
          map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
          map("]d", vim.diagnostic.goto_next, "Next diagnostic")
        end,
      })
    end,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        pyright = {},
        ruff = {
          init_options = {
            settings = {
              args = {},
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
        clangd = {},
        html = {},
        cssls = {},
        tailwindcss = {},
        eslint = {},
        emmet_language_server = {
          filetypes = {
            "css",
            "html",
            "javascriptreact",
            "less",
            "sass",
            "scss",
            "typescriptreact",
          },
        },
        ts_ls = {},
      }

      for name, server in pairs(servers) do
        server.capabilities = capabilities
        vim.lsp.config(name, server)
      end

      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },
}

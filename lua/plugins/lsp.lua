local function ensure_mason_tools()
  if #vim.api.nvim_list_uis() == 0 then
    return
  end

  local registry = require("mason-registry")
  local packages = {
    "clangd",
    "css-lsp",
    "emmet-language-server",
    "eslint-lsp",
    "html-lsp",
    "prettier",
    "prettierd",
    "basedpyright",
    "ruff",
    "rust-analyzer",
    "tailwindcss-language-server",
    "vtsls",
  }

  local function install_missing()
    for _, name in ipairs(packages) do
      local ok, pkg = pcall(registry.get_package, name)
      if ok and not pkg:is_installed() then
        pkg:install()
      end
    end
  end

  registry.refresh(vim.schedule_wrap(install_missing))
end

local function ts_client(bufnr)
  return vim.lsp.get_clients({ bufnr = bufnr, name = "vtsls" })[1]
end

local function ts_source_action(kind)
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { kind },
      diagnostics = {},
    },
  })
end

local function ts_organize_imports(bufnr)
  local client = ts_client(bufnr)
  if not client then
    vim.notify("vtsls is not attached to this buffer", vim.log.levels.WARN)
    return
  end

  client:request("workspace/executeCommand", {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(bufnr) },
  }, function(err)
    if err then
      vim.notify("TypeScript organize imports failed: " .. err.message, vim.log.levels.ERROR)
    end
  end, bufnr)
end

local function ts_go_to_source_definition(bufnr)
  local client = ts_client(bufnr)
  if not client then
    vim.notify("vtsls is not attached to this buffer", vim.log.levels.WARN)
    return
  end

  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)

  client:exec_cmd({
    command = "_typescript.goToSourceDefinition",
    title = "Go to source definition",
    arguments = { params.textDocument.uri, params.position },
  }, { bufnr = bufnr }, function(err, result)
    if err then
      vim.notify("Go to source definition failed: " .. err.message, vim.log.levels.ERROR)
      return
    end

    if not result or vim.tbl_isempty(result) then
      vim.notify("No source definition found", vim.log.levels.INFO)
      return
    end

    vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
  end)
end

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
    config = function(_, opts)
      require("mason").setup(opts)
      vim.schedule(ensure_mason_tools)
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "basedpyright",
        "ruff",
        "rust_analyzer",
        "clangd",
        "html",
        "cssls",
        "tailwindcss",
        "eslint",
        "emmet_language_server",
        "vtsls",
      },
      automatic_enable = {
        exclude = {
          "ts_ls",
        },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason-lspconfig.nvim",
    },
    init = function()
      local group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
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

          if client and client:supports_method("textDocument/inlayHint") then
            pcall(vim.lsp.inlay_hint.enable, true, { bufnr = args.buf })
          end

          if client and client.name == "vtsls" then
            map("gD", function()
              ts_go_to_source_definition(args.buf)
            end, "Go to source definition")
            map("<leader>co", function()
              ts_organize_imports(args.buf)
            end, "Organize imports")
            map("<leader>cu", function()
              ts_source_action("source.removeUnusedImports.ts")
            end, "Remove unused imports")
            map("<leader>cM", function()
              ts_source_action("source.addMissingImports.ts")
            end, "Add missing imports")
          end
        end,
      })
    end,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local enabled_servers = {}

      local function has_executable_cmd(config)
        if type(config.cmd) == "function" then
          return true
        end

        if type(config.cmd) == "table" and config.cmd[1] then
          return vim.fn.executable(config.cmd[1]) == 1
        end

        return false
      end

      local servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                inlayHints = {
                  callArgumentNames = true,
                  functionReturnTypes = true,
                  genericTypes = true,
                  variableTypes = true,
                },
              },
            },
          },
        },
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
        eslint = {
          settings = {
            workingDirectory = { mode = "auto" },
            format = false,
          },
        },
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
        vtsls = {
          settings = {
            vtsls = {
              autoUseWorkspaceTsdk = true,
            },
            javascript = {
              preferGoToSourceDefinition = true,
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = {
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
              },
            },
            typescript = {
              preferGoToSourceDefinition = true,
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
              },
            },
          },
        },
      }

      vim.diagnostic.config({
        severity_sort = true,
        float = {
          border = "rounded",
        },
      })

      for name, server in pairs(servers) do
        server.capabilities = capabilities
        vim.lsp.config(name, server)

        if has_executable_cmd(vim.lsp.config[name]) then
          table.insert(enabled_servers, name)
        end
      end

      table.sort(enabled_servers)
      vim.lsp.enable(enabled_servers)
    end,
  },
}

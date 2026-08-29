return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "f3fora/cmp-spell",
    "windwp/nvim-autopairs",
  },

  opts = function()
    local cmp = require("cmp")
    local context = require("cmp.config.context")
    local react = require("config.ft.react")

    local prose_filetypes = {
      gitcommit = true,
      markdown = true,
      plaintex = true,
      text = true,
      typst = true,
    }

    local function spell_completion_enabled()
      if prose_filetypes[vim.bo.filetype] then
        return true
      end

      local ok, in_spell_capture = pcall(context.in_treesitter_capture, "spell")
      return ok and in_spell_capture
    end

    local function append_return_semicolon()
      vim.schedule(function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local close_line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]

        if close_line and close_line:match("^%s*%)$") then
          vim.api.nvim_buf_set_lines(0, row, row + 1, false, { close_line .. ";" })
        end
      end)
    end

    local function cr(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
        return
      end

      local keys
      local add_semicolon = false
      if vim.bo.filetype == "javascriptreact" or vim.bo.filetype == "typescriptreact" then
        keys, add_semicolon = react.cr()
      else
        local ok, npairs = pcall(require, "nvim-autopairs")
        if ok then
          keys = npairs.autopairs_cr()
        end
      end

      if keys then
        vim.api.nvim_feedkeys(keys, "n", false)
        if add_semicolon then
          append_return_semicolon()
        end
      else
        fallback()
      end
    end

    return {
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping(cr, { "i", "s" }),
      }),

      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
        {
          name = "spell",
          option = {
            enable_in_context = spell_completion_enabled,
          },
        },
      }, {
        { name = "buffer" },
      }),
    }
  end,

  config = function(_, opts)
    local cmp = require("cmp")
    cmp.setup(opts)

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}

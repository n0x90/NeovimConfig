return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },

  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "saadparwaiz1/cmp_luasnip",
    "windwp/nvim-autopairs",
  },

  opts = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      if col == 0 then
        return false
      end

      local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
      return text:sub(col, col):match("%s") == nil
    end

    return {
      preselect = cmp.PreselectMode.None,

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-y>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() and has_words_before() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() and has_words_before() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
    }
  end,

  config = function(_, opts)
    local cmp = require("cmp")
    local npairs = require("nvim-autopairs")

    require("luasnip.loaders.from_vscode").lazy_load()
    npairs.setup({})
    cmp.setup(opts)

    _G.CmpPairsCR = function()
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
        if entry then
          cmp.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          })
          return ""
        end

        return npairs.esc("<C-e>") .. npairs.autopairs_cr()
      end

      return npairs.autopairs_cr()
    end

    vim.api.nvim_set_keymap("i", "<CR>", "v:lua.CmpPairsCR()", {
      expr = true,
      noremap = true,
      desc = "cmp/autopairs enter",
    })

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = "buffer" } },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
    })

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "c",
      "cpp",
      "css",
      "html",
      "javascript",
      "json",
      "lua",
      "python",
      "query",
      "regex",
      "rust",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
      disable = { "python", "rust" },
    },
  },
  config = function(_, opts)
    local ts = require("nvim-treesitter")
    ts.setup(opts)
    ts.install(opts.ensure_installed)

    local group = vim.api.nvim_create_augroup("treesitter_filetypes", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "*",
      callback = function(event)
        local filetype = vim.bo[event.buf].filetype
        local lang = vim.treesitter.language.get_lang(filetype)

        if not lang then
          return
        end

        if opts.highlight.enable and vim.treesitter.query.get(lang, "highlights") then
          pcall(vim.treesitter.start, event.buf, lang)
        end

        local indent_disabled = opts.indent.disable or {}
        if not opts.indent.enable then
          return
        end

        if vim.tbl_contains(indent_disabled, filetype) or vim.tbl_contains(indent_disabled, lang) then
          return
        end

        if vim.treesitter.query.get(lang, "indents") then
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}

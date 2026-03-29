return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  opts = {
    ensure_installed = {
      "lua",
      "python",
      "rust",
      "c",
      "cpp",
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      "json",
      "yaml",
      "vim",
      "vimdoc",
    },
    indent = {
      enable = true,
      disable = { "python", "rust" },
    },
  },
  config = function(_, opts)
    local ts = require("nvim-treesitter")
    local indent_disabled = {}

    for _, lang in ipairs(opts.indent.disable or {}) do
      indent_disabled[lang] = true
    end

    vim.treesitter.language.register("tsx", "javascriptreact")
    vim.treesitter.language.register("tsx", "typescriptreact")
    vim.treesitter.language.register("json", "jsonc")

    ts.setup()
    if #vim.api.nvim_list_uis() > 0 then
      ts.install(opts.ensure_installed)
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(event)
        local bufnr = event.buf
        local filetype = vim.bo[bufnr].filetype
        local ok, lang = pcall(vim.treesitter.language.get_lang, filetype)

        pcall(vim.treesitter.start, bufnr)

        if not ok or indent_disabled[lang] then
          return
        end

        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}

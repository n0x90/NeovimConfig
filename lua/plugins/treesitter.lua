return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",

  init = function()
    vim.treesitter.language.register("tsx", { "javascriptreact", "typescriptreact" })
    vim.treesitter.language.register("json", "jsonc")

    local indent_disabled = {
      python = true,
      rust = true,
    }

    local group = vim.api.nvim_create_augroup("treesitter_enable", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "*",
      callback = function(event)
        local filetype = vim.bo[event.buf].filetype
        local lang = vim.treesitter.language.get_lang(filetype)

        if not lang then
          return
        end

        if vim.treesitter.query.get(lang, "highlights") then
          pcall(vim.treesitter.start, event.buf, lang)
        end

        if vim.treesitter.query.get(lang, "indents") and not indent_disabled[lang] then
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,

  config = function()
    require("nvim-treesitter").install({
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
    })
  end,
}

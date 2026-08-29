return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    parsers = {
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
  },
  config = function(_, opts)
    local treesitter = require("nvim-treesitter")
    local install_dir = vim.fn.stdpath("data") .. "/site"
    local parser_set = {}

    for _, parser in ipairs(opts.parsers) do
      parser_set[parser] = true
    end

    treesitter.setup({ install_dir = install_dir })

    if not vim.tbl_contains(vim.opt.runtimepath:get(), install_dir) then
      vim.opt.runtimepath:prepend(install_dir)
    end

    if #vim.api.nvim_list_uis() > 0 then
      treesitter.install(opts.parsers)
    end

    local group = vim.api.nvim_create_augroup("user_treesitter", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function(args)
        local filetype = vim.bo[args.buf].filetype
        local parser = vim.treesitter.language.get_lang(filetype) or filetype

        if not parser_set[parser] then
          return
        end

        pcall(vim.treesitter.start, args.buf, parser)

        if parser ~= "python" and parser ~= "rust" then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}

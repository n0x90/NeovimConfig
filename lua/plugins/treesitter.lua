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
      -- LSP hover documentation uses Markdown, including in Python buffers.
      "markdown",
      "markdown_inline",
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

    local installing = false
    local reported_errors = {}

    local function attach(bufnr)
      if not vim.api.nvim_buf_is_loaded(bufnr) then
        return
      end

      local filetype = vim.bo[bufnr].filetype
      local parser = vim.treesitter.language.get_lang(filetype) or filetype
      if not parser_set[parser] then
        return
      end

      local ok, err = pcall(vim.treesitter.start, bufnr, parser)
      if not ok then
        -- Missing parsers are expected until the asynchronous install finishes.
        if not installing and not reported_errors[parser] then
          reported_errors[parser] = true
          vim.notify(("Tree-sitter (%s): %s"):format(parser, err), vim.log.levels.ERROR)
        end
        return
      end

      if parser ~= "python" and parser ~= "rust" then
        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    local group = vim.api.nvim_create_augroup("user_treesitter", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function(args)
        attach(args.buf)
      end,
    })

    if #vim.api.nvim_list_uis() > 0 then
      installing = true
      treesitter.install(opts.parsers):await(vim.schedule_wrap(function(err, success)
        installing = false
        if err or success == false then
          vim.notify(
            "Tree-sitter parser installation failed. Check :TSLog."
              .. (err and ("\n" .. tostring(err)) or ""),
            vim.log.levels.ERROR
          )
        end

        -- First installation may create a parser directory absent from the runtime cache.
        vim.opt.runtimepath:prepend(install_dir)

        -- FileType may have fired before a requested parser was available.
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          attach(bufnr)
        end
      end))
    end
  end,
}

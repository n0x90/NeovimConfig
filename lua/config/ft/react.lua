local M = {}

function M.cr()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before = line:sub(1, col)
  local after = line:sub(col + 1)
  local termcodes = vim.api.nvim_replace_termcodes

  if before:match("^%s*return%s*%($") and after:match("^%)") then
    local ok, npairs = pcall(require, "nvim-autopairs")
    if ok then
      return npairs.autopairs_cr() .. termcodes("<C-t>", true, false, true), true
    end

    return termcodes("<CR><C-t>", true, false, true), true
  end

  local ok, npairs = pcall(require, "nvim-autopairs")
  if ok then
    return npairs.autopairs_cr(), false
  end

  return termcodes("<CR>", true, false, true), false
end

function M.setup()
  vim.opt_local.expandtab = true
  vim.opt_local.shiftwidth = 2
  vim.opt_local.tabstop = 2
  vim.opt_local.softtabstop = 2
end

return M

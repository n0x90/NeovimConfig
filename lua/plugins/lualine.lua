return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = function()
    local theme = "auto"

    local ok, catppuccin_lualine = pcall(require, "catppuccin.utils.lualine")
    if ok then
      theme = catppuccin_lualine()
    end

    return {
      options = {
        theme = theme,
        globalstatus = true,
      },
    }
  end,
}

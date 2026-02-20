 local function get_kde_appearance()
  local handle = io.popen(
    "sh -c 'kreadconfig6 --file kdeglobals --group General --key ColorScheme 2>/dev/null || kreadconfig5 --file kdeglobals --group General --key ColorScheme 2>/dev/null'"
  )
  if not handle then
    return "latte"
  end

  local result = handle:read("*a") or ""
  handle:close()

  return result:match("[Dd]ark") and "mocha" or "latte"
end

return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,

  opts = function()
    return {
      flavour = get_kde_appearance(),
      background = {
        light = "latte",
        dark = "mocha",
      },
    }
  end,

  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
return {
  "windwp/nvim-ts-autotag",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-ts-autotag").setup({
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,
    })
  end,
}

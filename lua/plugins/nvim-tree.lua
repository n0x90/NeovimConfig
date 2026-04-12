return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>e",
      function()
        require("nvim-tree.api").tree.toggle({
          find_file = true,
          focus = true,
          update_root = true,
        })
      end,
      desc = "Toggle file tree",
    },
    {
      "<leader>E",
      function()
        require("nvim-tree.api").tree.find_file({
          open = true,
          focus = true,
          update_root = true,
        })
      end,
      desc = "Reveal file in tree",
    },
  },
  opts = function()
    local api = require("nvim-tree.api")

    local function on_attach(bufnr)
      api.map.on_attach.default(bufnr)

      vim.keymap.set("n", "gf", function()
        api.tree.find_file({
          open = true,
          focus = true,
          update_root = true,
        })
      end, {
        buffer = bufnr,
        desc = "nvim-tree: Find current file",
        noremap = true,
        silent = true,
        nowait = true,
      })
    end

    return {
      on_attach = on_attach,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = {
          enable = true,
        },
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      modified = {
        enable = true,
      },
      view = {
        width = 36,
        preserve_window_proportions = true,
      },
      renderer = {
        group_empty = true,
        highlight_git = "name",
        highlight_opened_files = "name",
        indent_markers = {
          enable = false,
        },
      },
      actions = {
        open_file = {
          resize_window = true,
        },
      },
    }
  end,
}

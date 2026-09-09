return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
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

    local function is_file_buffer(bufnr)
      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then
        return false
      end

      local name = vim.api.nvim_buf_get_name(bufnr)
      return name ~= "" and vim.fn.isdirectory(name) == 0
    end

    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("user_nvim_tree_last_file", { clear = true }),
      callback = function(event)
        if is_file_buffer(event.buf) then
          vim.t.nvim_tree_last_file = event.buf
        end
      end,
    })

    local function on_attach(bufnr)
      api.map.on_attach.default(bufnr)

      vim.keymap.set("n", "gf", function()
        local file_bufnr = vim.t.nvim_tree_last_file
        if not is_file_buffer(file_bufnr) then
          return
        end

        api.tree.find_file({
          buf = file_bufnr,
          open = true,
          focus = true,
          update_root = true,
        })
      end, {
        buffer = bufnr,
        desc = "nvim-tree: Find current file",
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

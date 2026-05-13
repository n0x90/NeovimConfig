return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    { "<leader>tt", desc = "Terminal (float)" },
    { "<leader>tb", desc = "Terminal (bottom)" },
  },
  opts = {
    start_in_insert = true,
    close_on_exit = true,
    shade_terminals = true,
    float_opts = {
      border = "rounded",
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local Terminal = require("toggleterm.terminal").Terminal
    local terminals = {}

    local function valid_dir(dir)
      return dir and vim.fn.isdirectory(dir) == 1
    end

    local function terminal_dir()
      local cwd = vim.fn.getcwd()
      if valid_dir(cwd) then
        return cwd
      end

      return vim.env.HOME or "."
    end

    local function find_venv_dir(start_dir)
      local venv = vim.fs.find(".venv", {
        path = start_dir,
        upward = true,
        type = "directory",
      })[1]

      if not venv then
        return nil
      end

      local python = vim.fs.joinpath(venv, "bin", "python")
      if vim.fn.executable(python) ~= 1 then
        return nil
      end

      return venv
    end

    local function terminal_env(venv)
      if not venv then
        return nil
      end

      return {
        VIRTUAL_ENV = venv,
        PATH = vim.fs.joinpath(venv, "bin") .. ":" .. vim.env.PATH,
      }
    end

    local function terminal_key(direction, dir, venv)
      return table.concat({ direction, dir, venv or "" }, "\n")
    end

    local function get_terminal(direction)
      local dir = terminal_dir()
      local venv = find_venv_dir(dir)
      local key = terminal_key(direction, dir, venv)

      if terminals[key] then
        return terminals[key]
      end

      terminals[key] = Terminal:new({
        direction = direction,
        dir = dir,
        env = terminal_env(venv),
        hidden = true,
        size = direction == "horizontal" and 15 or nil,
      })

      return terminals[key]
    end

    vim.keymap.set("n", "<leader>tt", function()
      get_terminal("float"):toggle()
    end, { desc = "Terminal (float)" })

    vim.keymap.set("n", "<leader>tb", function()
      get_terminal("horizontal"):toggle()
    end, { desc = "Terminal (bottom)" })
  end,
}

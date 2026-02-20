return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "DAP continue" },
      { "<leader>do", function() require("dap").step_over() end, desc = "DAP step over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "DAP step into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "DAP step out" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "DAP REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "DAP run last" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "DAP terminate" },
    },

    init = function()
      vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "R", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticWarn", linehl = "Visual" })
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = { "python" },
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-nvim-dap").setup(opts)
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI toggle" },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
    config = function(_, opts)
      require("nvim-dap-virtual-text").setup(opts)
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "williamboman/mason.nvim",
    },
    config = function()
      local function join(...)
        return table.concat({ ... }, "/")
      end

      local function debugpy_python_from_mason()
        local ok, mr = pcall(require, "mason-registry")
        if not ok then
          return nil
        end

        if not mr.has_package("debugpy") then
          return nil
        end

        local pkg = mr.get_package("debugpy")
        if not (pkg and pkg:is_installed()) then
          return nil
        end

        local install_path = nil
        if type(pkg.get_install_path) == "function" then
          install_path = pkg:get_install_path()
        elseif type(pkg.install_path) == "string" then
          install_path = pkg.install_path
        end

        if not install_path then
          return nil
        end

        local venv = install_path .. "/venv"

        if vim.fn.has("win32") == 1 then
          local p = join(venv, "Scripts", "python.exe")
          return vim.uv.fs_stat(p) and p or nil
        end

        local p = join(venv, "bin", "python")
        return vim.uv.fs_stat(p) and p or nil
      end

      local python_path = debugpy_python_from_mason() or "python"
      require("dap-python").setup(python_path)
    end,
  },
}
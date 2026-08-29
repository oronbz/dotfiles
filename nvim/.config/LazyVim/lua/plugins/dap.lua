return {
  -- Ensure Delve (Go debugger) is installed via Mason
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "delve" } },
  },

  -- nvim-dap: extend (not replace) the DAP core config
  -- Adds xcodebuild adapter + Go debugging via nvim-dap-go
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "wojciech-kulik/xcodebuild.nvim",
      { "leoluz/nvim-dap-go", opts = {} },
    },
    -- Use opts function to register xcodebuild's DAP adapter (codelldb)
    -- This merges with DAP core's config instead of replacing it
    opts = function()
      require("xcodebuild.integrations.dap").setup()
    end,
    -- stylua: ignore
    keys = {
      -- Xcode-specific debug keymaps (standard DAP keymaps like breakpoints,
      -- continue, step, terminate come from the DAP Core extra)
      { "<leader>dd", function() require("xcodebuild.integrations.dap").build_and_debug() end, desc = "Build & Debug (Xcode)" },
      { "<leader>dr", function() require("xcodebuild.integrations.dap").debug_without_build() end, desc = "Debug Without Building (Xcode)" },
      { "<leader>dT", function() require("xcodebuild.integrations.dap").debug_tests() end, desc = "Debug Tests (Xcode)" },
      { "<leader>dX", function() require("xcodebuild.integrations.dap").debug_class_tests() end, desc = "Debug Class Tests (Xcode)" },
      { "<leader>b", function() require("xcodebuild.integrations.dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (Xcode)" },
      { "<leader>B", function() require("xcodebuild.integrations.dap").toggle_message_breakpoint() end, desc = "Toggle Message Breakpoint" },
      -- Go-specific debug keymaps (only active in Go files)
      { "<leader>dGt", function() require("dap-go").debug_test() end, desc = "Debug Nearest Test (Go)", ft = "go" },
      { "<leader>dGl", function() require("dap-go").debug_last_test() end, desc = "Debug Last Test (Go)", ft = "go" },
    },
  },

  -- nvim-dap-ui: customise layout and icons via opts (merges with DAP core's config)
  {
    "rcarriga/nvim-dap-ui",
    -- DAP core already handles dependencies, setup(), and auto-open/close listeners.
    -- We only need to provide our custom opts which get passed to dapui.setup(opts).
    opts = {
      controls = {
        element = "repl",
        enabled = true,
        icons = {
          disconnect = "󱂷",
          run_last = "󰑓",
          terminate = "⏹︎",
          pause = "⏸︎",
          play = "󰐊",
          step_into = "󰆹",
          step_out = "󰆸",
          step_over = "󰒚",
          step_back = "󰒛",
        },
      },
      floating = {
        border = "single",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      icons = {
        collapsed = "󰌤",
        expanded = "󰌢",
        current_frame = "󰓘",
      },
      layouts = {
        {
          elements = {
            { id = "stacks", size = 0.25 },
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            { id = "repl", size = 0.4 },
            { id = "console", size = 0.6 },
          },
          position = "bottom",
          size = 10,
        },
      },
    },
    config = function(_, opts)
      local dapui = require("dapui")
      dapui.setup(opts)

      -- Auto-open/close DAP UI on debug events
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Hide ~ in DAP UI buffers
      local group = vim.api.nvim_create_augroup("dapui_config", { clear = true })
      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = group,
        pattern = "DAP*",
        callback = function()
          vim.wo.fillchars = "eob: "
        end,
      })
      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = group,
        pattern = "\\[dap\\-repl\\]",
        callback = function()
          vim.wo.fillchars = "eob: "
        end,
      })
    end,
  },
}

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, _)
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          swift = { "swiftformat" },
        },
      })
    end,
  }
}

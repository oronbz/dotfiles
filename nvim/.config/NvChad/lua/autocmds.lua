require "nvchad.autocmds"

-- Auto-cd to the directory passed as argument
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local argv = vim.fn.argv()
    if #argv == 1 then
      local stat = vim.loop.fs_stat(argv[1])
      if stat and stat.type == "directory" then
        vim.cmd.cd(argv[1])
      end
    end
  end,
})

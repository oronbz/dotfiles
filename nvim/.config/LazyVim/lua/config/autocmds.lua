-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("User", {
  pattern = { "XcodebuildBuildFinished", "XcodebuildTestsFinished" },
  callback = function(event)
    if event.data.cancelled then
      return
    end

    if event.data.success then
      require("trouble").close()
    elseif not event.data.failedCount or event.data.failedCount > 0 then
      if next(vim.fn.getqflist()) then
        require("trouble").open("quickfix")
      else
        require("trouble").close()
      end

      require("trouble").refresh()
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("resolve_symlinks", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local real = vim.uv.fs_realpath(file)
    if real and real ~= file then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) and vim.api.nvim_buf_get_name(args.buf) == file then
          vim.api.nvim_buf_set_name(args.buf, real)
          vim.api.nvim_buf_call(args.buf, function()
            vim.cmd("silent! edit!")
          end)
        end
      end)
    end
  end,
})

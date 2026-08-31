-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Source - https://stackoverflow.com/a/79656109
-- Posted by Jo Totland
-- Retrieved 2026-02-04, License - CC BY-SA 4.0

vim.o.tabstop = 4      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4  -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4   -- Number of spaces inserted when indenting
vim.o.undofile = false -- Disable persistent undo
vim.o.winbar = "%=%m %f"

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

vim.g.autoformat = false

-- refresh files if changed outside
vim.fn.timer_start(2000, function()
  vim.cmd("silent! checktime")
end, { ["repeat"] = -1 })



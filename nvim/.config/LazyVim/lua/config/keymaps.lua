-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>fT", function() Snacks.terminal(nil, { win = { position = "right" }}) end, { desc = "Terminal (cwd)" })
vim.keymap.set("n", "<leader>ft", function() Snacks.terminal(nil, { win = { position = "right" }, cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
vim.keymap.set({"n","t"}, "<c-/>",function() Snacks.terminal(nil, { win = { position = "right" }, cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
vim.keymap.set({"n","t"}, "<c-_>",function() Snacks.terminal(nil, { win = { position = "right" }, cwd = LazyVim.root() }) end, { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>h", Snacks.dashboard.open, { desc = "Open Dashboard" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })


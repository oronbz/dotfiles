if true then return {} end

return {
    "nvim-telescope/telescope-file-browser.nvim",
    keys = {
        { "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
    },
    config = function()
        require("telescope").load_extension("file_browser")
    end,
}

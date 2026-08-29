return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "swift", "lua", "vim" }, -- add swift here
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function(_, opts)
            -- Add queries to rtp so mini.ai can find textobjects.scm
            vim.opt.rtp:append(
                vim.fn.stdpath("data") .. "/lazy/nvim-treesitter-textobjects"
            )
        end,
    },
}

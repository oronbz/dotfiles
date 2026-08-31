return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                sourcekit = {
                    mason = false,
                    cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) },
                },
            },
        },
    },
}

return {
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library",              words = { "vim%.uv" } },
                -- Load Neovim runtime libraries
                { path = vim.env.VIMRUNTIME .. "/lua",      words = { "vim%." } },

                -- Explicitly load vim.api definitions
                { path = vim.env.VIMRUNTIME .. "/lua/vim/", words = { "vim%.api" } },
            },
        },
    },
    { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
}

return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {},
        config = function()
            require("tokyonight").setup({
                -- your configuration comes here
                -- or leave it empty to use the defal
                style = "storm", -- The theme comes :
                transparent = true, -- Enable this to
                terminal_colors = true, -- Configure
                styles = {
                    -- Style to be applied to differ
                    -- Value is any valid attr-list
                    comments = { italic = false },
                    keywords = { italic = false },
                    sidebars = "dark", -- style for
                    floats = "dark", -- style for flo
                }
            })
        end
    },
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        lazy = false,
        config = function()
            vim.cmd('colorscheme rose-pine')
            function ColorMyPencils(color)
                color = color or "rose-pine"
                vim.cmd.colorscheme(color)

                vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
                vim.api.nvim_set_hl(0, "NormalFloat", { bg = "None" })
            end

            ColorMyPencils()
        end
    },
}

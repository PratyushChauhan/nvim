return{
        'rose-pine/neovim',
        name = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
         function ColorMyPencils(color)
                print("color my pencil")
                color = color or "rose-pine"
                vim.cmd.colorscheme(color)

                vim.api.nvim_set_hl(0,"Normal",{bg = "None" })
                vim.api.nvim_set_hl(0,"NormalFloat",{bg = "None" })
            end
            ColorMyPencils()
        end
}

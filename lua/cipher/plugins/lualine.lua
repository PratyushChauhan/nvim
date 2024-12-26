function greet_based_on_time()
    -- Get the current hour from the system time
    local hour = tonumber(os.date("%H"))

    -- Determine the time of day and print an appropriate greeting
    if hour >= 5 and hour < 12 then
        return "Good Morning"
    elseif hour >= 12 and hour < 17 then
        return "Good Afternoon"
    elseif hour >= 17 and hour < 21 then
        return "Good Evening"
    else
        return "Good Night"
    end
end

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lua/lsp-status.nvim' },
    config = function()
        Data = string.format("%s Pratyush!", greet_based_on_time())
        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                always_divide_middle = true,
                globalstatus = true,
                refresh = { -- Faster refresh for dynamic updates
                    statusline = 100,
                    tabline = 100,
                    winbar = 100,
                },
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { 'filename', 'Data', },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            extensions = {}
        }
    end
}

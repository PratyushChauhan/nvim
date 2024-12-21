-- State to track floating window
local state = {
    floating = {
        buf = nil,
        win = nil,
    },
}

local function create_centered_float()
    -- Get the editor's dimensions
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    -- Calculate window size (80% of screen)
    local win_height = math.floor(height * 0.8)
    local win_width = math.floor(width * 0.8)

    -- Calculate starting position to center the window
    local row = math.floor((height - win_height) / 2)
    local col = math.floor((width - win_width) / 2)

    -- Set up the window options
    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = "rounded"  -- This creates rounded corners
    }

    -- Create a new buffer
    local buf = vim.api.nvim_create_buf(false, true)

    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Optional: Set window-local options
    vim.api.nvim_win_set_option(win, 'winblend', 0)  -- Opacity (0-100)
    vim.api.nvim_win_set_option(win, 'winhl', 'Normal:Normal')  -- Window highlighting

    return buf, win
end

local function toggleFloat()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_centered_float()
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

-- Command to toggle the floating window
vim.api.nvim_create_user_command('ToggleFloatingTerminal', function()
    toggleFloat()
end, {})


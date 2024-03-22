-- Reference: https://www.linode.com/docs/guides/write-a-neovim-plugin-with-lua/

local namespace_id = vim.api.nvim_create_namespace('FindHighlighterNamespace')

local M = {}

function M.highlight_in_line(char, backwards)
    -- get current line text
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local col_number = cursor_pos[2]
    local line_number = cursor_pos[1] - 1
    local line_text = vim.api.nvim_buf_get_lines(0, line_number, line_number + 1, false)[1]

    local start_col, end_col

    if backwards == true then
        start_col = 0
        end_col = col_number - 1
    else
        start_col = col_number + 1
        end_col = #line_text - 1
    end

    -- highlight occurrences in line
    for i = start_col, end_col do
        if line_text:sub(i + 1, i + 1) == char then
            vim.api.nvim_buf_set_extmark(0, namespace_id, line_number, i,
                { end_row = line_number, end_col = i + 1, hl_group = 'Search' })
        end
    end
end

function M.find_and_highlight_forwards()
    local key = vim.fn.getchar()
    local input_char = vim.fn.nr2char(key)

    M.highlight_in_line(input_char, false)

    -- run find command with input character
    vim.api.nvim_feedkeys('f' .. input_char, 'n', false)
end

function M.find_and_highlight_backwards()
    local key = vim.fn.getchar()
    local input_char = vim.fn.nr2char(key)

    M.highlight_in_line(input_char, true)

    -- run find command with input character
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<s-f>' .. input_char, true, true, true), 'n', false)
end

function M.clear_highlight()
    vim.api.nvim_buf_clear_namespace(0, namespace_id, 0, -1)
end

local function press_escape()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, true, true), 'n', false)
end

function M.setup()
    local modes = { 'n', 'v', 's', 'x' }
    vim.keymap.set(modes, 'f', M.find_and_highlight_forwards, { noremap = true, silent = true });
    vim.keymap.set(modes, '<s-f>', M.find_and_highlight_backwards, { noremap = true, silent = true });
    vim.keymap.set(modes, '<esc>',
        function()
            M.clear_highlight()
            press_escape()
        end, { noremap = true, silent = true });
end

return M

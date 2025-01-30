local hotplate = require('hotplate')
local utils = require('hotplate.utils')
local M = {}

M.bufId = nil
M.winId = nil


local function createWindow()
    local bufId, winId
    -- if no buffer exists make one
    bufId = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(bufId, "buftype", "acwrite")
    if BP_Table ~= nil then
        local keys = utils.getKeys(BP_Table)
        vim.api.nvim_buf_set_text(bufId, -1, -1, -1, -1, keys)
    end

    -- setup centering
    local ui = vim.api.nvim_list_uis()[1]
    local col = 15
    local row = 12
    local width = 100
    local height = 20
    if ui ~= nil then
        col = math.floor((ui.width-width)/2)
        row = math.floor((ui.height-height)/2)
    end

    winId = vim.api.nvim_open_win(bufId, true, {
        relative='win',
        row=row,
        col=col,
        width=width,
        height=height,
        border='rounded',
        title=' Hotplate ',
        title_pos='center',
    })

    return {windowId=winId, bufferId=bufId}
end

local function closeWindow()
    -- if window exists close it
    if vim.api.nvim_win_is_valid(M.winId) then
        vim.api.nvim_win_close(M.winId, true)
        M.winId = nil
    end
    if vim.api.nvim_buf_is_valid(M.bufId) then
        vim.api.nvim_buf_delete(M.bufId, {force = true})
        M.bufId = nil
    end
end

M.toggleFloat = function()
    if M.winId ~= nil then
        closeWindow()
        return
    end

    local winInfo = createWindow()

    M.winId = winInfo.windowId
    M.bufId = winInfo.bufferId

    vim.api.nvim_buf_set_keymap(
    M.bufId,
    "n",
    "<Esc>",
    "<Cmd>lua require('hotplate.ui').toggleFloat()<CR>",
    { silent = true }
    )
    vim.api.nvim_buf_set_keymap(
    M.bufId,
    "n",
    "<CR>",
    "<Cmd>lua require('hotplate.ui').selectItem()<CR>",
    { silent = true }
    )
    vim.api.nvim_buf_set_keymap(
    M.bufId,
    "n",
    "dd",
    "<Cmd>lua require('hotplate.ui').deleteItem()<CR>",
    { silent = true }
    )

end

M.selectItem = function()
    local cursor = vim.api.nvim_win_get_cursor(M.winId)[1]-1
    local value = (vim.api.nvim_buf_get_lines(M.bufId, cursor, cursor+1, false))[1]
    hotplate.useBP(value)
end

M.deleteItem = function()
    local cursor = vim.api.nvim_win_get_cursor(M.winId)[1]-1
    local value = (vim.api.nvim_buf_get_lines(M.bufId, cursor, cursor+1, false))[1]
    hotplate.removeBP(value)
end

return M

local utils = require('hotplate.utils')
local M = {}
BP_Table = {}

M.setup = function()
    local ok
    -- calling readutils.userData with param userData
    ok, BP_Table = pcall(utils.readUserData, utils.userData)

    if not ok then
        print('failed to read user data')
        BP_Table = {}
    end
end

M.addBP = function(name)
    if name == nil then
        name = utils.getName('Enter boilierplate name: \n')
    end

    -- gathering starting and end position of selection
    local visEnd = vim.fn.getpos("v")[2]
    local cursor = vim.fn.getpos(".")[2]
    -- start and end line only
    local startPos
    local endPos
    -- handling different methods of highlighting
    if visEnd > cursor then
        startPos = cursor
        endPos = visEnd
    else
        startPos = visEnd
        endPos=cursor
    end
    -- gathering all selected terms into table
    -- startPos -1 b/c of indexing conflict b/w nvim & lua
    local totalSelect = vim.api.nvim_buf_get_lines(0, startPos-1, endPos, false)
    -- non-blocking look for alternative
    vim.api.nvim_input("<esc>")

    BP_Table[name] = totalSelect
    utils.writeUserData()
end

M.removeBP = function(name)
    BP_Table[name] = nil
    utils.writeUserData()
end

M.useBP = function(value)
    vim.api.nvim_put(BP_Table[value], "", true, false)
end

M.clearBP = function()
    BP_Table = {}
    utils.writeUserData()
end

M.setup()

return M

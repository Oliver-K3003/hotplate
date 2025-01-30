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

M.addBP = function()
    local name = utils.getName('Enter boilierplate name: \n')

    -- gathering starting and end position of selection
    local vStart = vim.fn.getpos(".")
    local vEnd = vim.fn.getpos("v")
    -- start and end line only
    local startPos = vStart[2]
    local endPos = vEnd[2]
    -- gathering all selected terms into table
    local totalSelect = vim.fn.getline(startPos, endPos)
    -- non-blocking look for alternative
    vim.api.nvim_input("<esc>")

    BP_Table[name] = totalSelect
    utils.writeUserData()
end

M.removeBP = function(name)
--    local name
    local keys = utils.getKeys(BP_Table)
--    vim.ui.select(keys, {
--        prompt = 'Select boilierplate to delete',
--        format_item = function(item)
--            return (item)
--        end,
--    }, function(choice)
--        name = choice
--    end)

    BP_Table[name] = nil
    utils.writeUserData()
end

M.useBP = function(value)
    if BP_Table[value] then
        vim.api.nvim_put(BP_Table[value], "", true, true)
    else
        print('provided name is empty')
    end
end

M.clearBP = function()
    BP_Table = {}
    utils.writeUserData()
end

M.setup()

return M

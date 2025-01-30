local Path = require("plenary.path")
local M = {}

M.dataPath = vim.fn.stdpath('data')
M.userData = string.format("%s/hotplate.json", M.dataPath)


-- gets user input to set bp name
M.getName = function(prompt)
    local name
    vim.ui.input({ prompt = prompt }, function(input)
        name = input
    end)
    return name
end

-- get stored bp data for user
M.readUserData = function(localData)
    return vim.json.decode(Path:new(localData):read())
end

-- write new data to user storage
M.writeUserData = function()
    if BP_Table ~= nil then
        Path:new(M.userData):write(vim.fn.json_encode(BP_Table), "w")
    else
        Path:new(M.userData):write((""), "w")
    end
end

-- returns keys from table
M.getKeys = function(inputTable)
    local keys = {}
    local n = 0
    for key, val in pairs(inputTable) do
        n = n + 1
        keys[n] = key
    end
    return keys
end

return M

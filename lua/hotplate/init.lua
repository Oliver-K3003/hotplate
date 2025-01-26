local Path = require("plenary.path")

local dataPath = vim.fn.stdpath('data')
local userData = string.format("%s/hotplate.json", dataPath)

local M = {}
BP_Table = {}

local function getName(prompt)
    local name
    vim.ui.input({ prompt = prompt }, function(input)
       name = input
    end)
    return name
end

local function readUserData(localData)
    return vim.json.decode(Path:new(localData):read())
end

local function writeUserData()
    Path:new(userData):write(vim.fn.json_encode(BP_Table), "w")
end

M.setup = function()
    local ok
    ok, BP_Table = pcall(readUserData, userData)

    if not ok then
        print('failed to read user data')
        BP_Table = {}
    end
end

M.addBP = function()
    local name = getName('Enter boilierplate name: \n')

    -- gathering starting and end position of selection 
    local vStart = vim.fn.getpos("'<")
    local vEnd = vim.fn.getpos("'>")
    -- start and end line only
    local startPos = vStart[2]
    local endPos = vEnd[2]
    -- gathering all selected terms into table
    local totalSelect = vim.fn.getline(startPos, endPos)

    BP_Table[name] = totalSelect
    writeUserData()
end

M.removeBP = function()
    local name = getName('Enter name to remove: \n')
    BP_Table[name] = nil
    writeUserData()
end

M.useBP = function()
    local name = getName('Enter boilierplate name to use: \n')
    if BP_Table[name] then
        vim.api.nvim_put(BP_Table[name], "", true, true)
    else
        print('provided name is empty')
    end
end

M.listBP = function()
    print(vim.inspect(BP_Table))
end

M.setup()

return M

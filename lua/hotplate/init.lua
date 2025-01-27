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
    local vStart = vim.fn.getpos(".")
    local vEnd = vim.fn.getpos("v")
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
    local name
    local keys = {}
    local n = 0
    for key, val in pairs(BP_Table) do
        n = n+1
        keys[n] = key
    end
    vim.ui.select(keys, {
        prompt = 'Select boilierplate to use',
        format_item = function(item)
            return(item)
        end,
    }, function(choice)
        name = choice
    end)

    if BP_Table[name] then
        vim.api.nvim_put(BP_Table[name], "", true, true)
    else
        print('provided name is empty')
    end
end

M.listBP = function()
    vim.notify(vim.inspect(BP_Table), INFO)
end

M.setup()

return M

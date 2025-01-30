local hp = require('hotplate')
local eq = assert.are.same

local function tableEq(tb1, tb2)
    if tb1 == tb2 then return true end
    local tb1Type = type(tb1)
    local tb2Type = type(tb2)
    if tb1Type ~= tb2Type then return false end
    if tb1Type ~= 'table' then return false end

    local keySet = {}

    for key1, value1 in pairs(tb1) do
        local value2 = tb2[key1]
        if value2 == nil or tableEq(value1, value2) == false then
            return false
        end
        keySet[key1] = true
    end

    for key2, _ in pairs(tb2) do
        if not keySet[key2] then return false end
    end
    return true
end

describe("hotplate", function()
    it("require testing", function()
        require('hotplate')
    end)
    it("test deleting from table", function()
        hp.clearBP()

        eq(true, tableEq(BP_Table, {}))

        hp.addBP('cmake')

        local testtable = {cmake={""}}

        eq(true, tableEq(BP_Table, testtable))

        hp.removeBP('cmake')

        eq(true, tableEq(BP_Table, {}))
    end)
end)

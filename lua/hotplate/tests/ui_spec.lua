local ui = require('hotplate.ui')
local hp = require('hotplate')
local eq = assert.are.same

describe("hotplate", function()
    it("toggle the window", function()
        eq(ui.bufId, nil)
        eq(ui.winId, nil)

        ui.toggleFloat()

        eq(true, vim.api.nvim_buf_is_valid(ui.bufId))
        eq(true, vim.api.nvim_win_is_valid(ui.winId))

        ui.toggleFloat()

        eq(ui.bufId, nil)
        eq(ui.winId, nil)
    end)
    it("delete update", function()
        hp.addBP('cmake')
        eq(ui.bufId, nil)
        eq(ui.winId, nil)

        ui.toggleFloat()

        eq(true, vim.api.nvim_buf_is_valid(ui.bufId))
        eq(true, vim.api.nvim_win_is_valid(ui.winId))

        ui.selectItem()
    end)
end)

local winwidth_limit = 85

local conditions = {
    buffer_not_empty = function()
        local buf = vim.fn.expand "%:t"

        return buf ~= ""
    end,
    should_hide_in_width = function()
        return vim.o.columns > winwidth_limit
    end,
}

return conditions

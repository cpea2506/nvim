vim.on_key(function(char)
    if vim.api.nvim_get_mode().mode ~= "n" then
        return
    end

    local should_enable = vim.iter({ "/", "?", "*", "#", "n", "N" }):any(function(key)
        return char == key
    end)

    if vim.o.hlsearch ~= should_enable then
        vim.o.hlsearch = should_enable
    end
end, vim.api.nvim_create_namespace "pea_auto_hlsearch", {})

local event_handler = require "lazy.core.handler.event"
local lazy_file_mapping = {
    id = "LazyFile",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
}

event_handler.mappings.LazyFile = lazy_file_mapping
event_handler.mappings["User LazyFile"] = lazy_file_mapping

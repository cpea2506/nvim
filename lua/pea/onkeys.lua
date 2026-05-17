local function namespace(name)
    return vim.api.nvim_create_namespace("pea_" .. name)
end

local listeners = {
    {
        function(char)
            if vim.api.nvim_get_mode().mode == "n" then
                local hlsearch = vim.iter({ "/", "?", "*", "#", "n", "N" }):any(function(v)
                    return char == v
                end)

                if vim.o.hlsearch ~= hlsearch then
                    vim.o.hlsearch = hlsearch
                end
            end
        end,
        namespace "auto_hlsearch",
    },
}

for _, listener in pairs(listeners) do
    vim.on_key(listener[1], listener[2], listener[3])
end

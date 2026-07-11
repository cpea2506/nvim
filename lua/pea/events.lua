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

local augroup = vim.api.nvim_create_augroup("pea_plugin", { clear = false })

lib.create_autocmds {
    {
        "CmdlineChanged",
        augroup,
        { pattern = { ":", "?", "/" } },
        function()
            vim.fn.wildtrigger()
        end,
    },
    {
        "CompleteChanged",
        augroup,
        function()
            local info = vim.fn.complete_info { "selected" }
            ---@type integer
            local winid = info.preview_winid

            if winid and vim.api.nvim_win_is_valid(winid) then
                vim.api.nvim_win_set_config(winid, { border = "rounded" })
            end
        end,
    },
}

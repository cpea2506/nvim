local augroup = vim.api.nvim_create_augroup("pea_plugin", { clear = false })

vim.pack.add({
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/saghen/blink.lib",
    "https://github.com/saghen/blink.pairs",
    "https://github.com/rafamadriz/friendly-snippets",
}, { load = false })

lib.create_autocmds {
    {
        "PackChanged",
        augroup,
        function(args)
            local name, kind = args.data.spec.name, args.data.kind

            if name == "blink.pairs" and (kind == "install" or kind == "update") then
                if not args.data.active then
                    vim.cmd.packadd "blink.lib"
                    vim.cmd.packadd "blink.pairs"
                end

                require("blink.pairs").build():pwait()
            end
        end,
    },
    {
        { "BufReadPost", "BufNewFile" },
        augroup,
        { once = true },
        function()
            vim.cmd.packadd "blink.lib"
            vim.cmd.packadd "blink.pairs"

            require("blink.pairs").setup {
                highlights = {
                    groups = {
                        "RainbowDelimiterRed",
                        "RainbowDelimiterOrange",
                        "RainbowDelimiterYellow",
                        "RainbowDelimiterGreen",
                        "RainbowDelimiterBlue",
                        "RainbowDelimiterViolet",
                        "RainbowDelimiterCyan",
                    },
                },
            }
        end,
    },
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

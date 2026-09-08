local augroup = vim.api.nvim_create_augroup("pea_plugin", { clear = false })

vim.pack.add({
    "https://github.com/saghen/blink.lib",
    "https://github.com/saghen/blink.pairs",
    "https://github.com/cpea2506/relative-toggle.nvim",
    "https://github.com/cpea2506/input.nvim",
    "https://github.com/cpea2506/select.nvim",
    "https://github.com/kylechui/nvim-surround",
    "https://github.com/nacro90/numb.nvim",
    "https://github.com/stevearc/quicker.nvim",
}, { load = false })

vim.schedule(function()
    vim.cmd.packadd "input.nvim"
    vim.cmd.packadd "select.nvim"
end)

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
        "UIEnter",
        augroup,
        { once = true },
        function()
            vim.cmd.packadd "relative-toggle.nvim"
        end,
    },
    {
        { "BufReadPost", "BufNewFile" },
        augroup,
        { once = true },
        function()
            vim.cmd.packadd "nvim-surround"
        end,
    },
    {
        "CmdlineEnter",
        augroup,
        { pattern = ":", once = true },
        function()
            vim.cmd.packadd "numb.nvim"

            require("numb").setup {
                number_only = true,
            }
        end,
    },
    {
        "FileType",
        augroup,
        { pattern = "qf", once = true },
        function()
            vim.cmd.packadd "quicker.nvim"

            require("quicker").setup {
                type_icons = {
                    E = lib.icons.diagnostics.ERROR,
                    W = lib.icons.diagnostics.WARN,
                    I = lib.icons.diagnostics.INFO,
                    H = lib.icons.diagnostics.HINT,
                },
            }
        end,
    },
}

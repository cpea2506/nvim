vim.pack.add { "https://github.com/cpea2506/relative-toggle.nvim" }

vim.schedule(function()
    vim.pack.add {
        "https://github.com/cpea2506/input.nvim",
        "https://github.com/cpea2506/select.nvim",
        "https://github.com/kylechui/nvim-surround",
    }
end)

local augroup = vim.api.nvim_create_augroup("pea_plugin", { clear = false })

lib.create_autocmds {
    {
        "CmdlineEnter",
        augroup,
        { pattern = ":", once = true },
        function()
            vim.pack.add { "https://github.com/nacro90/numb.nvim" }

            require("numb").setup {
                number_only = true,
            }
        end,
    },
    {
        "InsertEnter",
        augroup,
        { once = true },
        function()
            vim.pack.add { "https://github.com/max397574/better-escape.nvim" }

            require("better_escape").setup {
                default_mappings = false,
                mappings = {
                    i = {
                        j = {
                            k = "<Esc>",
                        },
                    },
                },
            }
        end,
    },
    {
        "FileType",
        augroup,
        { pattern = "qf", once = true },
        function()
            vim.pack.add { "https://github.com/stevearc/quicker.nvim" }

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

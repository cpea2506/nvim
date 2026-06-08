return {
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts = {
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            },
            ui = {
                border = "rounded",
                keymaps = {
                    toggle_package_expand = "o",
                    uninstall_package = "d",
                },
                icons = {
                    package_installed = lib.icons.ui.ThinTick,
                    package_pending = lib.icons.ui.ArrowRight,
                    package_uninstalled = lib.icons.ui.Close,
                },
            },
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
    },
    {
        "seblyng/roslyn.nvim",
        ft = "cs",
        opts = {
            filewatching = "roslyn",
        },
    },
    {
        "saecki/crates.nvim",
        event = "BufRead Cargo.toml",
        opts = {
            date_format = "%d-%m-%Y",
            popup = {
                autofocus = true,
                border = "rounded",
            },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
            completion = {
                crates = {
                    enabled = true,
                    max_results = 8,
                    min_chars = 3,
                },
            },
        },
    },
}

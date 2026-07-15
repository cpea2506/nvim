local augroup = vim.api.nvim_create_augroup("pea_plugin", { clear = false })

vim.schedule(function()
    vim.pack.add { "https://github.com/mason-org/mason.nvim" }

    require("mason").setup {
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
    }
end)

lib.create_autocmds {
    {
        { "BufReadPost", "BufNewFile" },
        augroup,
        { once = true },
        vim.schedule_wrap(function()
            vim.pack.add { "https://github.com/neovim/nvim-lspconfig" }

            local registry = require "mason-registry"

            vim.iter(registry.get_installed_packages()):each(function(pkg)
                local spec = pkg.spec
                local server = spec.neovim and spec.neovim.lspconfig

                if server then
                    vim.lsp.enable(server, true)
                end
            end)
        end),
    },
    {
        "FileType",
        augroup,
        { pattern = "cs", once = true },
        function()
            vim.pack.add { "https://github.com/seblyng/roslyn.nvim" }

            require("roslyn").setup {
                filewatching = "roslyn",
            }
        end,
    },
    {
        "BufRead",
        augroup,
        { pattern = "Cargo.toml", once = true },
        function()
            vim.pack.add { "https://github.com/saecki/crates.nvim" }

            require("crates").setup {
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
            }
        end,
    },
}

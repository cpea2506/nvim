return {
    "A7Lavinraj/fyler.nvim",
    event = "LazyFile",
    keys = {
        { "<leader>e", "<cmd>Fyler<cr>", desc = "Open Explorer" },
    },
    opts = {
        integrations = {
            icon = "nvim_web_devicons",
        },
        views = {
            finder = {
                close_on_select = true,
                confirm_simple = false,
                default_explorer = true,
                delete_to_trash = true,
                follow_current_file = true,
                icon = {
                    directory_collapsed = lib.icons.kind.Folder,
                    directory_expanded = lib.icons.ui.FolderExpanded,
                    directory_empty = lib.icons.ui.FolderEmpty,
                },
                columns = {
                    git = {
                        enabled = false,
                    },
                    diagnostic = {
                        enabled = false,
                    },
                },
                indentscope = {
                    enabled = true,
                },
                watcher = {
                    enabled = true,
                },
                win = {
                    border = "rounded",
                    kind = "float",
                    kind_presets = {
                        float = {
                            height = "80%",
                            width = "80%",
                            top = "7.5%",
                            left = "7.5%",
                        },
                    },
                    win_opts = {
                        number = vim.o.number,
                    },
                },
            },
        },
    },
}

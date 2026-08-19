vim.schedule(function()
    vim.pack.add {
        "https://github.com/nvim-telescope/telescope.nvim",
        "https://github.com/nvim-lua/plenary.nvim",
    }

    local telescope = require "telescope"
    local actions = require "telescope.actions"

    telescope.setup {
        defaults = {
            prompt_prefix = lib.icons.ui.Telescope .. " ",
            selection_caret = lib.icons.ui.ChevronRight .. " ",
            dynamic_preview_title = true,
            results_title = false,
            path_display = {
                "smart",
                "filename_first",
            },
            file_ignore_patterns = { "%.meta", "%.fbx" },
            sorting_strategy = "ascending",
            layout_strategy = "vertical",
            layout_config = {
                anchor = "CENTER",
                width = 0.5,
                height = 0.85,
                prompt_position = "top",
            },
        },
        pickers = {
            find_files = {
                preview = false,
                hidden = true,
                layout_config = {
                    height = 0.35,
                    width = 0.4,
                },
            },
            buffers = {
                mappings = {
                    i = {
                        ["<C-x>"] = actions.delete_buffer + actions.move_to_top,
                    },
                },
            },
        },
    }

    lib.set_keymaps {
        { "n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "Find Files" } },
        { "n", "<leader>st", "<cmd>Telescope live_grep<cr>", { desc = "Find Grep" } },
        { "n", "<leader>sb", "<cmd>Telescope buffers<cr>", { desc = "Find Buffers" } },
    }
end)

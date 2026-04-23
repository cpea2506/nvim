return {
    {
        "saghen/blink.cmp",
        build = "cargo build --release",
        version = "*",
        dependencies = {
            "mikavilpas/blink-ripgrep.nvim",
            "rafamadriz/friendly-snippets",
        },
        event = {
            "InsertEnter",
            "CmdlineEnter",
        },
        opts = function()
            local icons = require "pea.ui.icons"
            local devicons = require "nvim-web-devicons"

            return {
                fuzzy = {
                    implementation = "rust",
                    sorts = {
                        "exact",
                        "score",
                        "sort_text",
                    },
                },
                keymap = {
                    preset = "none",
                    ["<C-k>"] = { "select_prev", "fallback" },
                    ["<C-j>"] = { "select_next", "fallback" },
                    ["<C-d>"] = { "scroll_documentation_up", "fallback" },
                    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                    ["<CR>"] = { "accept", "fallback" },
                    ["<Tab>"] = {
                        function(cmp)
                            if cmp.snippet_active() then
                                return cmp.accept()
                            else
                                return cmp.select_and_accept()
                            end
                        end,
                        "snippet_forward",
                        "fallback",
                    },
                    ["<S-Tab>"] = { "snippet_backward", "fallback" },
                },
                completion = {
                    accept = {
                        dot_repeat = false,
                        resolve_timeout_ms = 1000,
                    },
                    ghost_text = {
                        enabled = true,
                        show_with_selection = true,
                        show_without_selection = false,
                    },
                    menu = {
                        draw = {
                            treesitter = { "lsp" },
                            columns = { { "kind_icon" }, { "label", "label_description", gap = 1, "source_name" } },
                            components = {
                                kind_icon = {
                                    text = function(ctx)
                                        local icon = nil

                                        if ctx.source_id == "path" then
                                            local devicon, _ = devicons.get_icon(ctx.label)

                                            if devicon then
                                                icon = devicon
                                            end
                                        end

                                        if not icon then
                                            icon = icons.kind[ctx.kind] or ctx.kind_icon
                                        end

                                        return icon .. ctx.icon_gap .. " "
                                    end,
                                    highlight = function(ctx)
                                        if ctx.source_id == "path" then
                                            local devicon, devhl = devicons.get_icon(ctx.label)

                                            if devicon then
                                                return devhl
                                            end
                                        end

                                        return ctx.kind_hl
                                    end,
                                },
                                source_name = {
                                    text = function(ctx)
                                        return "(" .. ctx.source_name .. ")"
                                    end,
                                },
                            },
                        },
                        direction_priority = function()
                            local cmp = require "blink.cmp"
                            local ctx = cmp.get_context()
                            local item = cmp.get_selected_item()

                            if ctx == nil or item == nil then
                                return { "s", "n" }
                            end

                            local item_text = item.textEdit ~= nil and item.textEdit.newText
                                or item.insertText
                                or item.label
                            local is_multi_line = item_text:find "\n" ~= nil

                            if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
                                vim.g.blink_cmp_upwards_ctx_id = ctx.id

                                return { "n", "s" }
                            end

                            return { "s", "n" }
                        end,
                    },
                    documentation = {
                        auto_show = true,
                        auto_show_delay_ms = 250,
                    },
                },
                signature = {
                    enabled = true,
                    trigger = {
                        show_on_insert = true,
                    },
                },
                sources = {
                    default = function()
                        local success, node = pcall(vim.treesitter.get_node)

                        if
                            success
                            and node
                            and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type())
                        then
                            return { "buffer", "ripgrep" }
                        else
                            return { "lsp", "path", "snippets", "buffer", "ripgrep" }
                        end
                    end,
                    providers = {
                        ripgrep = {
                            module = "blink-ripgrep",
                            opts = {
                                backend = {
                                    use = "gitgrep-or-ripgrep",
                                    ripgrep = {
                                        search_casing = "--smart-case",
                                    },
                                },
                            },
                        },
                        snippets = {
                            opts = {
                                extended_filetypes = {
                                    cs = { "unity" },
                                },
                            },
                            should_show_items = function(ctx)
                                return ctx.trigger.initial_kind ~= "trigger_character"
                            end,
                        },
                    },
                },
                cmdline = {
                    enabled = true,
                    completion = {
                        menu = {
                            auto_show = true,
                            draw = {
                                columns = { { "kind_icon" }, { "label" } },
                            },
                        },
                        list = {
                            selection = {
                                preselect = false,
                                auto_insert = true,
                            },
                        },
                    },
                    sources = function()
                        local type = vim.fn.getcmdtype()

                        if type == "/" or type == "?" then
                            return { "buffer", "ripgrep" }
                        end

                        if type == ":" or type == "@" then
                            return { "cmdline", "buffer" }
                        end

                        return {}
                    end,
                    keymap = {
                        ["<C-k>"] = { "select_prev", "fallback" },
                        ["<C-j>"] = { "select_next", "fallback" },
                        ["<Tab>"] = { "select_and_accept", "fallback" },
                        ["<CR>"] = { "accept_and_enter", "fallback" },
                    },
                },
            }
        end,
    },
    {
        "saghen/blink.pairs",
        build = "cargo build --release",
        event = "LazyFile",
        opts = {
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
        },
    },
}

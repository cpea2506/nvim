local augroup = vim.api.nvim_create_augroup("pea_plugin", { clear = false })

vim.pack.add({
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/saghen/blink.lib",
    "https://github.com/saghen/blink.pairs",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/saghen/blink.cmp",
}, { load = false })

lib.create_autocmds {
    {
        "PackChanged",
        augroup,
        function(args)
            local name, kind = args.data.spec.name, args.data.kind

            if name == "blink.cmp" and (kind == "install" or kind == "update") then
                if not args.data.active then
                    vim.cmd.packadd "blink.lib"
                    vim.cmd.packadd "blink.cmp"
                end

                require("blink.cmp").build():pwait()
            end

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
        { "InsertEnter", "CmdlineEnter" },
        augroup,
        { once = true },
        function()
            vim.cmd.packadd "nvim-web-devicons"
            vim.cmd.packadd "blink.lib"
            vim.cmd.packadd "friendly-snippets"
            vim.cmd.packadd "blink.cmp"

            require("blink.cmp").setup {
                fuzzy = {
                    implementation = "rust",
                    sorts = {
                        "exact",
                        "score",
                        "sort_text",
                    },
                },
                keymap = {
                    preset = "super-tab",
                    ["<CR>"] = { "accept", "fallback" },
                },
                completion = {
                    accept = {
                        dot_repeat = false,
                    },
                    ghost_text = {
                        enabled = true,
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
                                            local devicons = require "nvim-web-devicons"
                                            local devicon, _ = devicons.get_icon(ctx.label)

                                            if devicon then
                                                icon = devicon
                                            end
                                        end

                                        if not icon then
                                            icon = lib.icons.kind[ctx.kind] or ctx.kind_icon
                                        end

                                        return icon .. ctx.icon_gap .. " "
                                    end,
                                    highlight = function(ctx)
                                        if ctx.source_id == "path" then
                                            local devicons = require "nvim-web-devicons"
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
                        local node = vim.npcall(vim.treesitter.get_node)

                        if
                            node
                            and vim.iter({ "comment", "line_comment", "block_comment" }):any(function(v)
                                return node:type() == v
                            end)
                        then
                            return { "buffer" }
                        else
                            return { "lsp", "path", "snippets", "buffer" }
                        end
                    end,
                    providers = {
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
                            },
                        },
                    },
                    sources = {
                        default = function()
                            local type = vim.fn.getcmdtype()

                            if type == "/" or type == "?" then
                                return { "buffer" }
                            end

                            if type == ":" or type == "@" then
                                return { "cmdline", "buffer" }
                            end

                            return {}
                        end,
                    },
                },
            }
        end,
    },
}

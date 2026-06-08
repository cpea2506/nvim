local colors = require "pea.plugins.lualine.colors"

local function buffer_not_empty()
    local buf = vim.fn.expand "%:t"

    return buf ~= ""
end

local function should_hide_in_width()
    local winwidth_limit = 85

    return vim.o.columns > winwidth_limit
end

local components = {
    leftbar = {
        function()
            return lib.icons.ui.HeavyLine
        end,
        color = { fg = colors.blue },
        padding = { left = 0, right = 1 },
    },
    evil = {
        function()
            -- auto change color according to neovims mode
            local mode_color = {
                n = colors.red,
                i = colors.green,
                v = colors.blue,
                [""] = colors.blue,
                V = colors.blue,
                c = colors.magenta,
                no = colors.red,
                s = colors.orange,
                S = colors.orange,
                [""] = colors.orange,
                ic = colors.yellow,
                R = colors.violet,
                Rv = colors.violet,
                cv = colors.red,
                ce = colors.red,
                r = colors.cyan,
                rm = colors.cyan,
                ["r?"] = colors.cyan,
                ["!"] = colors.red,
                t = colors.red,
            }

            vim.api.nvim_set_hl(0, "LualineMode", {
                fg = mode_color[vim.api.nvim_get_mode().mode],
                bg = colors.bg,
            })

            return lib.icons.ui.Evil
        end,
        color = "LualineMode",
        padding = { right = 1 },
    },
    filesize = {
        "filesize",
        cond = buffer_not_empty,
    },
    diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = {
            error = lib.icons.diagnostics.ERROR .. " ",
            warn = lib.icons.diagnostics.WARN .. " ",
            info = lib.icons.diagnostics.INFO .. " ",
        },
        diagnostics_color = {
            color_error = { fg = colors.red },
            color_warn = { fg = colors.yellow },
            color_info = { fg = colors.cyan },
        },
    },
    center = {
        "%=",
    },
    lsp = {
        function()
            local bufnr = vim.api.nvim_get_current_buf()
            local buf_clients = vim.lsp.get_clients { bufnr = bufnr }
            local buf_client_names = { "LS Inactive" }

            if #buf_clients ~= 0 then
                buf_client_names = {}
            end

            for _, client in pairs(buf_clients) do
                buf_client_names[#buf_client_names + 1] = client.name
            end

            -- Add formatters.
            local formatters = require("conform").list_formatters(bufnr)
            local formatter_names = vim.iter(formatters)
                :map(function(v)
                    return v.name
                end)
                :totable()
            vim.list_extend(buf_client_names, formatter_names)

            -- Add linters.
            local linter_names = require("lint")._resolve_linter_by_ft(vim.bo.filetype)
            vim.list_extend(buf_client_names, linter_names)

            return table.concat(buf_client_names, (" %s "):format(lib.icons.ui.ThinLine))
        end,
        icon = lib.icons.ui.Setting .. " LSP:",
        color = { fg = colors.jungle_green, gui = "bold" },
    },
    branch = {
        "b:gitsigns_head",
        icon = lib.icons.git.Branch,
        color = { fg = colors.violet, gui = "bold" },
        cond = should_hide_in_width,
    },
    filetype = {
        "filetype",
        cond = should_hide_in_width,
    },
    location = {
        "location",
        cond = should_hide_in_width,
    },
    os = {
        function()
            return lib.is_windows and lib.icons.ui.Windows or lib.icons.ui.Apple
        end,
        cond = should_hide_in_width,
        color = { fg = lib.is_windows and colors.cerulean or colors.fg },
    },
    encoding = {
        "o:encoding",
        cond = should_hide_in_width,
        color = { fg = colors.green, gui = "bold" },
    },
    treesitter = {
        function()
            local bufnr = vim.api.nvim_get_current_buf()
            local active_status = vim.treesitter.highlighter.active[bufnr]

            return active_status and lib.icons.ui.Treesitter .. " " or ""
        end,
        color = { fg = colors.green },
        padding = { right = 0 },
    },
    scrollbar = {
        function()
            local current = vim.api.nvim_win_get_cursor(0)[1]
            local total = vim.api.nvim_buf_line_count(0)
            local chars = lib.icons.ui.Scrollbar
            local index = math.ceil(current / total * #chars)

            return chars[index]
        end,
        color = { fg = colors.yellow },
        padding = { left = 1 },
    },
    macro = {
        function()
            local reg = vim.fn.reg_recording()

            return reg ~= "" and "recording @" .. reg or ""
        end,
        color = { fg = colors.orange },
        draw_empty = false,
    },
    debug = {
        require "pea.plugins.lualine.components.debug",
        color = { fg = colors.magenta },
        draw_empty = false,
    },
}

return components

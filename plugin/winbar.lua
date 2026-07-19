vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("pea_plugin", { clear = false }),
    once = true,
    callback = function()
        vim.pack.add {
            "https://github.com/nvim-tree/nvim-web-devicons",
            "https://github.com/SmiteshP/nvim-navic",
        }

        local navic = require "nvim-navic"

        navic.setup {
            icons = vim.iter(lib.icons.kind)
                :map(function(icon)
                    return icon .. " "
                end)
                :totable(),
            lsp = {
                auto_attach = true,
            },
            highlight = true,
        }

        local function is_empty(s)
            return s == nil or s == ""
        end

        local function get_filename()
            local filename = vim.fn.expand "%:t"

            if is_empty(filename) then
                return ""
            end

            local extension = vim.fs.ext(filename)
            local devicons = require "nvim-web-devicons"
            local fileicon, hlgroup = devicons.get_icon(filename, extension, { default = true })

            return " " .. "%#" .. hlgroup .. "#" .. fileicon .. "%*" .. " " .. "%#WinBar#" .. filename .. "%*"
        end

        local function get_locations(bufnr)
            local filename = get_filename()

            if not navic.is_available(bufnr) then
                return filename
            end

            local locations = navic.get_location(nil, bufnr)

            if is_empty(locations) then
                return filename
            end

            return filename .. "%#NavicSeparator# " .. lib.icons.ui.ChevronRight .. " %*" .. locations
        end

        vim.api.nvim_create_autocmd({ "BufWinEnter", "CursorHold", "CursorHoldI", "BufWritePost" }, {
            group = vim.api.nvim_create_augroup("pea_winbar", {}),
            callback = function(args)
                if vim.fn.win_gettype() == "popup" then
                    return
                end

                local bufnr = args.buf
                local exclude_filetypes = { "", "fyler_finder", "fzf", "help", "pager", "qf" }

                if
                    vim.iter(exclude_filetypes):any(function(v)
                        return vim.bo[bufnr].filetype == v
                    end)
                then
                    return
                end

                local winbar = get_locations(bufnr)

                if vim.bo[bufnr].mod then
                    winbar = winbar .. "%#LspCodeLens# " .. lib.icons.ui.Circle .. "%*"
                end

                vim.wo.winbar = winbar
            end,
        })
    end,
})

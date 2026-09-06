vim.pack.add({
    "https://github.com/nvim-tree/nvim-web-devicons",
}, { load = false })

lib.create_autocmd("UIEnter", vim.api.nvim_create_augroup("pea_plugin", { clear = false }), { once = true }, function()
    vim.cmd.packadd "nvim-web-devicons"

    local ns = vim.api.nvim_create_namespace "pea_plugins_dir"

    vim.api.nvim_set_decoration_provider(ns, {
        on_win = function(_, _, buf)
            return vim.bo[buf].filetype == "directory"
        end,
        ---@return integer
        on_range = function(_, _, buf, row, _, end_row)
            local name = vim.api.nvim_buf_get_lines(buf, row, end_row, true)[1]

            if not name then
                return end_row
            end

            local ext = vim.fs.ext(name)
            ---@type string, string
            local icon, hl = require("nvim-web-devicons").get_icon(name, ext, { default = true, strict = true })
            local stat = vim.uv.fs_stat(name)

            if stat and stat.type == "directory" then
                icon, hl = lib.icons.ui.FolderCollapsed, "directoryDirectoryIcon"
            end

            vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
                id = end_row,
                virt_text = { { icon, hl }, { " " } },
                virt_text_pos = "inline",
            })

            return end_row
        end,
    })
end)

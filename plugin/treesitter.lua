local augroup = vim.api.nvim_create_augroup "pea.plugin.treesitter"

vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
}, { load = function() end })

lib.create_autocmds {
    {
        "PackChanged",
        augroup,
        function(args)
            local name, kind = args.data.spec.name, args.data.kind

            if name == "nvim-treesitter" and kind == "update" then
                vim.cmd.packadd "nvim-treesitter"
                vim.cmd.TSUpdate()
            end
        end,
    },
    {
        { "BufReadPre", "BufNewFile" },
        augroup,
        { once = true },
        function()
            vim.cmd.packadd "nvim-treesitter"
            vim.cmd.packadd "nvim-treesitter-context"

            local context = require("treesitter-context")

            context.setup {
                mode = "cursor",
                max_lines = 3,
            }

            lib.set_keymap("n", "[c", function()
                context.go_to_context(vim.v.count1)
            end, { desc = "Go To Context" })

            lib.create_autocmd("FileType", augroup, function(args)
                local buf = args.buf
                local lang = vim.treesitter.language.get_lang(args.match) or args.match

                local treesitter = require "nvim-treesitter"
                local parsers = require "nvim-treesitter.parsers"

                if not parsers[lang] then
                    return
                end

                local parser = vim.treesitter.get_parser(buf, lang, { error = false })

                if not parser then
                    treesitter.install(lang):wait(30000)
                end

                vim.treesitter.start(buf, lang)

                if vim.treesitter.query.get(lang, "indents") then
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end)
        end,
    },
}

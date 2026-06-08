vim.loader.enable()

local lib = require "pea.lib"

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local err =
        vim.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }):wait().stderr

    if err ~= nil then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { err, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

lib.load_modules("pea", {
    "options",
    "autocmds",
    "keymaps",
    "onkeys",
    "events",
    "lsp",
    "ui",
})

require("lazy").setup("pea.plugins", {
    defaults = {
        lazy = true,
    },
    install = {
        colorscheme = { "one_monokai" },
    },
    ui = {
        border = "rounded",
        backdrop = 100,
        title = "Plugins",
        title_pos = "center",
    },
    checker = {
        enabled = true,
        frequency = 43200,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

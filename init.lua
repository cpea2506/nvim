vim.loader.enable()

_G.lib = require "pea.lib"

lib.require_modules("pea", {
    "options",
    "autocmds",
    "keymaps",
    "events",
    "ui",
    "lsp",
})

vim.loader.enable()

_G.lib = require "pea.lib"

lib.load_modules("pea", {
    "options",
    "autocmds",
    "keymaps",
    "events",
    "ui",
    "lsp",
})

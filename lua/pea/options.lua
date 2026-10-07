---@alias options table<string, any>
---@type { vim: options, global: options }
local options = {
    vim = {
        clipboard = "unnamedplus",
        cmdheight = 0,
        conceallevel = 2,
        confirm = true,
        cursorline = true,
        expandtab = true,
        fillchars = "eob: ",
        fixeol = false,
        guicursor = "i-ci-ve-t:hor30",
        laststatus = 3,
        linebreak = true,
        list = true,
        listchars = { "tab:⇤–⇥", "multispace:·", "trail:·", "precedes:⇠", "extends:⇢" },
        number = true,
        shiftwidth = 4,
        showmode = false,
        showtabline = 0,
        signcolumn = "yes",
        smartcase = true,
        smartindent = true,
        smoothscroll = true,
        splitbelow = true,
        splitright = true,
        swapfile = false,
        tabstop = 4,
        undofile = true,
        updatetime = 250,
        winborder = "rounded",
    },
    global = {
        mapleader = " ",
        health = { style = "float" },
        loaded_nvim_dir_plugin = false,
    },
}

for option, value in pairs(options.vim) do
    vim.o[option] = value
end

for option, value in pairs(options.global) do
    vim.g[option] = value
end

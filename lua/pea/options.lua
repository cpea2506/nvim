local options = {
    vim = {
        clipboard = "unnamedplus",
        cmdheight = 0,
        completeopt = "menu,menuone,noselect",
        conceallevel = 2,
        confirm = true,
        cursorline = true,
        expandtab = true,
        fileencoding = "utf-8",
        fillchars = "eob: ",
        fixeol = false,
        guicursor = "i-ci-ve-t:hor30",
        ignorecase = true,
        laststatus = 3,
        linebreak = true,
        list = true,
        listchars = "tab:⇤–⇥,multispace:·,trail:·,precedes:⇠,extends:⇢",
        swapfile = false,
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
        tabstop = 4,
        undofile = true,
        updatetime = 250,
        winborder = "rounded",
    },
    global = {
        mapleader = " ",
        health = { style = "float" },
    },
}

for option, value in pairs(options.vim) do
    vim.o[option] = value
end

for option, value in pairs(options.global) do
    vim.g[option] = value
end

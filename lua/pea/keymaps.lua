local lib = require "pea.lib"

lib.set_keymaps {
    { "n", "<leader>q", "<cmd>q<cr>" },
    { "n", "<C-s>", "<cmd>w<cr>" },
    { "n", "<C-e>", "<cmd>bd<cr>" },

    { "n", "<C-h>", "<C-w>h", { remap = true } },
    { "n", "<C-j>", "<C-w>j", { remap = true } },
    { "n", "<C-k>", "<C-w>k", { remap = true } },
    { "n", "<C-l>", "<C-w>l", { remap = true } },

    { "v", "<", "<gv" },
    { "v", ">", ">gv" },

    { "t", "<C-x>", "<C-\\><C-n>" },

    { "n", "<leader>ph", "<cmd>Lazy<cr>" },
    { "n", "<leader>ps", "<cmd>Lazy sync<cr>" },
}

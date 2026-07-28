lib.set_keymaps {
    { "i", "<C-h>", "<Left>", { desc = "Move left" } },
    { "i", "<C-l>", "<Right>", { desc = "Move right" } },
    { "i", "<C-j>", "<Down>", { desc = "Move down" } },
    { "i", "<C-k>", "<Up>", { desc = "Move up" } },

    { "n", "<C-h>", "<C-w>h", { desc = "Switch window left" } },
    { "n", "<C-j>", "<C-w>j", { desc = "Switch window down" } },
    { "n", "<C-k>", "<C-w>k", { desc = "Switch window up" } },
    { "n", "<C-l>", "<C-w>l", { desc = "Switch window right" } },

    { "n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" } },
    { "n", "<C-e>", "<cmd>bd<cr>", { desc = "Close buffer" } },

    { "n", "<leader>w", "<cmd>noautocmd w<cr>", { desc = "Save without autocmd" } },
    { "n", "<C-s>", "<cmd>w<cr>", { desc = "Save" } },

    { "v", "<", "<gv", { desc = "Move text" } },
    { "v", ">", ">gv" },
}

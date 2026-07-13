local function open_term(cmd, opts)
    opts = opts or {}

    if opts.size then
        vim.cmd(("botright %d vsplit | term %s"):format(opts.size, cmd))
    else
        vim.cmd(("tabnew | term %s"):format(cmd))
    end

    vim.cmd.startinsert()
end

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

    { "t", "<C-\\>", "<C-\\><C-n>" },

    { "n", "<leader>ph", "<cmd>Lazy<cr>" },
    { "n", "<leader>ps", "<cmd>Lazy sync<cr>" },

    {
        "n",
        "<leader>gg",
        function()
            open_term "lazygit"
        end,
    },
    {
        "n",
        "<leader>ai",
        function()
            open_term("opencode", { size = 80 })
        end,
    },
    {
        "n",
        "<leader>ac",
        function()
            open_term("opencode --continue", { size = 80 })
        end,
    },
}

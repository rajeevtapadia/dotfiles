return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        keymaps = {
            ["<C-p>"] = false,
        },
    },
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    lazy = false,
    config = function(_, opts)
        require("oil").setup(opts)

        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (Oil)" })
        vim.keymap.set("n", "<leader>e", "<CMD>Oil %:p:h<CR>", { desc = "Open Oil at file dir" })
        vim.keymap.set("n", "<leader>E", "<CMD>Oil<CR>", { desc = "Open Oil at cwd" })
        vim.keymap.set("n", "<leader>o", "<CMD>Oil --float<CR>", { desc = "Open Oil (float)" })
    end,
}

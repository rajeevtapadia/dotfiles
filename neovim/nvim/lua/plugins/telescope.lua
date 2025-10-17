return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin = require("telescope.builtin")
        -- VSCode-like Ctrl+P
        vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
        -- live grep like Ctrl+Shift+F
        vim.keymap.set("n", "g/", builtin.live_grep, { desc = "Live grep" })
    end
}

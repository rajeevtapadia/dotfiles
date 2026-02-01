return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin = require("telescope.builtin")
        local telescope = require('telescope')
        telescope.setup {
            pickers = {
                find_files = {
                    hidden = true
                }
            },
            defaults = {
                file_ignore_patterns = { "%.git/" },
            },
        }


        -- VSCode-like Ctrl+P
        vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
        -- live grep like Ctrl+Shift+F
        vim.keymap.set("n", "g/", builtin.live_grep, { desc = "Live grep" })
        vim.keymap.set('n', '<leader>fg', function()
            builtin.live_grep({ default_text = vim.fn.expand('<cword>') })
        end, { desc = "Live Grep Word Under Cursor" })
    end
}

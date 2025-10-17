return {
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup()

        -- Normal mode Ctrl+/
        vim.keymap.set('n', '<C-_>', function()
            require('Comment.api').toggle.linewise.current()
        end, { noremap = true, silent = true })

        -- Visual mode Ctrl+/
        vim.keymap.set('v', '<C-_>', function()
            local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
            vim.api.nvim_feedkeys(esc, 'nx', false)
            require('Comment.api').toggle.linewise(vim.fn.visualmode())
        end, { noremap = true, silent = true })
    end
}

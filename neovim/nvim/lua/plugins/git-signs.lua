return {
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                -- optional: custom signs (uncomment and tweak if you like)
                -- signs = {
                --   add          = {hl = 'GitGutterAdd', text = '+'},
                --   change       = {hl = 'GitGutterChange', text = '~'},
                --   delete       = {hl = 'GitGutterDelete', text = '_'},
                --   topdelete    = {hl = 'GitGutterDelete', text = '‾'},
                --   changedelete = {hl = 'GitGutterChange', text = '~'},
                -- },

                -- show inline blame
                current_line_blame = false,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                    delay = 200,
                },

                -- put mappings in on_attach to ensure the plugin is ready and buffer is a git file
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local opts = { buffer = bufnr, noremap = true, silent = true }

                    -- show blame popup for current line (floating window)
                    vim.keymap.set('n', '<leader>gb', function()
                        -- full = true will show full commit text (body) if available
                        gs.blame_line { full = true }
                    end, vim.tbl_extend('force', opts, { desc = 'Gitsigns: Blame Line (popup)' }))

                    -- toggle inline blame virtual text
                    vim.keymap.set('n', '<leader>gB', function()
                        gs.toggle_current_line_blame()
                    end, vim.tbl_extend('force', opts, { desc = 'Gitsigns: Toggle Inline Blame' }))

                    -- -- stage/reset hunk examples
                    -- vim.keymap.set('n', '<leader>gs', gs.stage_hunk,
                    --     vim.tbl_extend('force', opts, { desc = 'Stage Hunk' }))
                    -- vim.keymap.set('n', '<leader>gr', gs.reset_hunk,
                    --     vim.tbl_extend('force', opts, { desc = 'Reset Hunk' }))
                end, -- on_attach
            })
        end
    },
}

return {
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                -- signs = {
                --     add          = {hl = 'GitGutterAdd', text = '+'},
                --     change       = {hl = 'GitGutterChange', text = '~'},
                --     delete       = {hl = 'GitGutterDelete', text = '_'},
                --     topdelete    = {hl = 'GitGutterDelete', text = '‾'},
                --     changedelete = {hl = 'GitGutterChange', text = '~'},
                -- },
                -- keymaps = {
                --     -- Key mappings to navigate Git signs
                --     noremap = true,
                --     buffer = true,
                --     ['n <leader>gs'] = { ':Gitsigns stage_hunk<CR>', desc = 'Stage Hunk' },
                --     ['n <leader>gr'] = { ':Gitsigns reset_hunk<CR>', desc = 'Reset Hunk' },
                -- },
            })
        end
    },
}


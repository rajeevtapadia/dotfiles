require("config.lazy")

-- basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"

-- Highlight search
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.g.mapleader = " "
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>a', 'ggVG')

-- yank/paste to/from global registers
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')

-- quick fix list
vim.keymap.set('n', '<leader>j', '<cmd>cnext<CR>')
vim.keymap.set('n', '<leader>k', '<cmd>cprev<CR>')
vim.keymap.set('n', '<leader>q', function()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        vim.cmd('cclose')
    else
        vim.cmd('copen')
    end
end, { desc = "Toggle quickfix list" })

vim.diagnostic.config({
    virtual_text = true,      -- show inline messages
    signs = true,             -- keep the E/W in the gutter
    underline = true,         -- underline the problematic code
    update_in_insert = false, -- don't update while typing
    severity_sort = true,
})

-- Set tab width to 2 for js/ts
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.expandtab = true
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr }

        -- Common keymaps for LSP
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

        -- Autoformat files with Alt+Shift+F
        vim.keymap.set("n", "<M-F>", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- =========================
-- :Make - synchronous, uses :make
-- =========================
vim.api.nvim_create_user_command("Make", function(opts)
    local args = opts.args or ""
    -- run :make (use silent to avoid cluttering commandline)
    -- remove silent if you prefer to see the shell output inline
    vim.cmd("silent make " .. args)

    -- if quickfix has entries, open and jump to first
    local qfl = vim.fn.getqflist()
    if #qfl > 0 then
        vim.cmd("copen")
        vim.cmd("cc 1")
    else
        vim.notify("Build succeeded (no quickfix entries).", vim.log.levels.INFO)
    end
end, { nargs = "*", complete = "customlist,v:lua._make_complete" })

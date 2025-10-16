return {
    -- "rose-pine/neovim",
    -- "rebelot/kanagawa.nvim",
    -- "folke/tokyonight.nvim",
    "vague2k/vague.nvim",
    config = function()
        require("vague").setup({})
        vim.cmd.colorscheme("vague")
    end
}

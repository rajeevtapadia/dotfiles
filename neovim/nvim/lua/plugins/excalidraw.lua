return {
    {
        "marcocofano/excalidraw.nvim",
        config = function()
            require("excalidraw").setup({
                storage_dir = vim.fn.getcwd()
            })
        end
    }
}

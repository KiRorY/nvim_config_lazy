-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "markdown" },
    callback = function()
        vim.b.autoformat = false
        vim.diagnostic.enable(false)
        vim.opt_local.spell = false
    end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "cpp", "c", "python" },
    callback = function()
        vim.b.autoformat = false
        vim.opt_local.spell = false
    end,
})

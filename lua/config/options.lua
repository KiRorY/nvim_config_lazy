-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
local opt = vim.opt
opt.spelllang = { "en", "cjk" } -- 设置拼写检查，防止中文提示拼写错误
opt.shiftwidth = 4 -- 修改默认缩进
opt.tabstop = 4
vim.o.pumblend = 0
vim.o.winblend = 0

-- lsp border
local float = { focusable = true, style = "minimal", border = "rounded" }
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float)

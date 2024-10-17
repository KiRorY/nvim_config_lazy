-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("plugins.colorscheme")
require("plugins.dashboard")
require("plugins.leetcode")
require("plugins.cmp")
require("plugins.lsp")
require("plugins.copilot")

if vim.g.neovide then
    vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h15"
    vim.g.neovide_cursor_trail_size = 0.3
    vim.g.neovide_transparency = 0.98
    vim.g.neovide_background_image = "~/.config/nvim/NeovimLogo.png"
    -- vim.g.transparency = 0.4
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_remember_window_size = true
end

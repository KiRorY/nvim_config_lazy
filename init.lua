-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("plugins.colorscheme")
require("plugins.dashboard")
require("plugins.leetcode")
require("plugins.cmp")

if vim.g.neovide then
  vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h15"
  vim.g.neovide_cursor_trail_size = 0.3
  vim.g.neovide_transparency = 0.95
  vim.g.transparency = 0.3
  vim.g.neovide_refresh_rate = 60
  vim.g.remember_window_size = true
end

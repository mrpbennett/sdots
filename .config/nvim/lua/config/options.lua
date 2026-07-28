-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Enabling the mouse
vim.opt.mouse = "a"
-- Disable Swap
vim.opt.swapfile = false
-- Stop auto comments
vim.opt.formatoptions:remove({ "c", "r", "o" })

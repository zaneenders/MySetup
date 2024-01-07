-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.api.nvim_set_keymap("n", ";y", ":Telescope file_browser path=%:p:h select_buffer=true<CR><Esc>", { noremap = true })

vim.keymap.set("n", ";f", function()
  local builtin = require("telescope.builtin")
  builtin.find_files({
    no_ignore = true,
    hidden = true,
    file_ignore_patterns = { ".build", ".git", ".repositories" },
  })
end, {})
vim.keymap.set("n", ";g", function()
  local builtin = require("telescope.builtin")
  builtin.live_grep({
    no_ignore = true,
    hidden = true,
    file_ignore_patterns = { ".build", ".git", ".repositories" },
  })
end, {})

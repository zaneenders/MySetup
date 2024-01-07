return {
  -- add gruvbox
  -- TODO overide colors
  -- https://github.com/ellisonleao/gruvbox.nvim
  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}

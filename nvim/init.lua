-- keybindings
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
-- tabs and spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2

vim.opt.scrolloff = 6
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus" -- fix copy paste?
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wrap = true

-- setup code folding with treesitter
-- za to open and close a single fold
-- zR to open all of the folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.keymap.set("i", "<c-c>", ":<Esc>", { noremap = true })

-- lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
-- End bootstrapping and setup

local plugins = {
  { "catppuccin/nvim",     name = "catppuccin", priority = 1000 },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  {
    "williamboman/mason.nvim",
  },
  {
    "neovim/nvim-lspconfig",
  },
  -- Lua Code formatting. not as good as the other one but works for now
  -- to format use the following command
  -- :lua require("stylua").format()
  { "wesleimp/stylua.nvim" },
  -- I don't really understand this yet
  -- https://wojciechkulik.pl/ios/the-complete-guide-to-ios-macos-development-in-neovim
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",           -- source for text in buffer
      "hrsh7th/cmp-path",             -- source for file system paths
      "L3MON4D3/LuaSnip",             -- snippet engine
      "saadparwaiz1/cmp_luasnip",     -- for autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets
      "onsails/lspkind.nvim",         -- vs-code like pictograms
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,preview",
        },
        snippet = { -- configure how nvim-cmp interacts with snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
          ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
          ["<C-Space>"] = cmp.mapping.complete(),     -- show completion suggestions
          ["<C-e>"] = cmp.mapping.abort(),            -- close completion window
          ["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }),
          ["<C-b>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-f>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        -- sources for autocompletion
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- snippets
          { name = "buffer" },  -- text within current buffer
          { name = "path" },    -- file system paths
        }),
        -- configure lspkind for vs-code like pictograms in completion menu
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },
}

local opts = {}

require("lazy").setup(plugins, opts)

-- Telescope setup
require("telescope").setup({
  extensions = {
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
})
require("telescope").load_extension("file_browser")
-- Maybe I can move these bindings to the config above
local builtin = require("telescope.builtin")
vim.keymap.set("n", ";t", ":Telescope file_browser<CR><Esc>", { noremap = true })
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

-- treesitter
local treeConfig = require("nvim-treesitter.configs")
treeConfig.setup({
  ensure_installed = {
    "lua",
    "swift",
    "racket",
    "css",
    "html",
    "javascript",
  },
  highlight = { enable = true },
  indent = { enable = true },
})

-- lsp

-- https://github.com/williamboman/mason.nvim
require("mason").setup()
-- https://github.com/neovim/nvim-lspconfig
require("lspconfig").lua_ls.setup({
  -- TODO fix undefined global
})
require("lspconfig").sourcekit.setup({
  -- finish config
  -- Maybe this can help
  -- https://wojciechkulik.pl/ios/the-complete-guide-to-ios-macos-development-in-neovim
})
require("lspconfig").cssls.setup({})
require("lspconfig").html.setup({
  opts = {
    settings = {
      html = {
        format = {
          templating = true,
          wrapLineLength = 120,
          wrapAttributes = "auto",
        },
        hover = {
          documentation = true,
          references = true,
        },
      },
      css = {
        lint = {
          validProperties = {},
        },
      },
    },
  },
  {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
      css = true,
      javascript = true,
    },
    provideFormatter = true,
  },
})

-- LSP Keybindings
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    -- TODO rebind
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf })
    vim.keymap.set("n", "<c-r>", vim.lsp.buf.format, { buffer = args.buf })
  end,
})

-- color scheme
-- https://github.com/catppuccin/nvim/#overwriting-colors
-- Maybe I can use this to do my scheme in Swift through C?
-- https://github.com/nullchilly/CatNvim/blob/main/init.c
-- this seems to work
-- https://github.com/catppuccin/nvim/#overwriting-colors
require("catppuccin").setup {
  transparent_background = true,
  color_overrides = {
    all = {
      text = "#67e344",       -- green
    },
    latte = {
      base = "#ff0000",
      mantle = "#242424",
      crust = "#474747",
    },
    frappe = {},
    macchiato = {},
    mocha = {},
  },
  custom_highlights = function(colors)
    return {
      Comment = { fg = "#dddddd" },
      TabLineSel = { bg = colors.pink },
      CmpBorder = { fg = colors.surface2 },
      Pmenu = { bg = colors.none },
    }
  end
}

vim.cmd([[colorscheme catppuccin]])

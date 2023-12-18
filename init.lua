local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Auto-install lazy.nvim if not present
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
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- Minimal Neovim settings (listed alphebetically).
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.numberwidth = 3
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 250
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[ ]]

-- Lazy.nvim setup.
require('lazy').setup({
  {'folke/tokyonight.nvim'},
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},

  { -- LSP Support
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    keys = {
      {"<leader>i", "<cmd>LspInfo<cr>", "Lsp Info"},
      {"<leader>I", "<cmd>LspInstall<cr>", "Lsp Install"},
    },
  },

  { -- LSP Config
    'neovim/nvim-lspconfig',
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
    }
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      {'L3MON4D3/LuaSnip'}
    },
  },

  { -- Use which-key to show lsp_zero default_keymaps
    'folke/which-key.nvim',
    event = "VeryLazy",
    config = function()
      require('which-key').setup(
      {plugins = {spelling = true}}
      )
    end,
  },

  { -- Vim/NeoVim/Tmux seamless navigation.
    "christoomey/vim-tmux-navigator",
    event =  "VeryLazy",
    keys = {
      {"<c-h>", "<cmd>TmuxNavigateLeft<cr>", "Navigate Window Left"},
      {"<c-j>", "<cmd>TmuxNavigateDown<cr>", "Navigate Window Down"},
      {"<c-k>", "<cmd>TmuxNavigateUp<cr>", "Navigate Window Up"},
      {"<c-l>", "<cmd>TmuxNavigateRight<cr>", "Navigate Window Right"},
    },
  },

  { -- File navigation
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim"
    },
    keys = {
      {"<c-n>", "<cmd>Neotree toggle<cr>"},
      {"<leader>nf", "<cmd>Neotree focus<cr>"},
    },

    opts = function(_, opts)
      opts.filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true}
      }
      opts.window = { position = "right", }
    end,
  },

})

-- A plesant colorcheme.
vim.cmd.colorscheme("tokyonight-night")

-- Use lsp_zero to manage lsp attachments.
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(_, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- Setup Mason and Mason-Config.
require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  },
})

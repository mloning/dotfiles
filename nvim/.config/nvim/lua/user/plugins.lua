-- Install lazy.nvim
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

-- Remap space as leader key
-- Make sure to set `mapleader` before lazy so your mappings are correct
local keymap = vim.keymap.set
keymap("", "<Space>", "<Nop>")
vim.g.mapleader = " "

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    return
end

-- Install your plugins here
return lazy.setup({
    "nvim-lua/plenary.nvim", -- Useful lua functions used by lots of plugins
    "windwp/nvim-autopairs", -- Autopairs, integrates with both cmp and treesitter
    "numToStr/Comment.nvim",
    "JoosepAlviste/nvim-ts-context-commentstring",
    "kyazdani42/nvim-web-devicons",
    "kyazdani42/nvim-tree.lua",
    "akinsho/bufferline.nvim",
    "moll/vim-bbye",
    "github/copilot.vim",
    {
        "zbirenbaum/copilot.lua",
        event = { "VimEnter" },
        config = function()
            vim.defer_fn(function()
                require("user.copilot")
            end, 100)
        end,
    },
    "mbbill/undotree",
    "nvim-lualine/lualine.nvim",
    "akinsho/toggleterm.nvim",
    "ahmedkhalf/project.nvim",
    "lewis6991/impatient.nvim",
    "goolord/alpha-nvim",
    -- "christoomey/vim-tmux-navigator"

    -- Colorschemes
    "folke/tokyonight.nvim",
    "lunarvim/darkplus.nvim",

    -- cmp plugins
    "hrsh7th/nvim-cmp", -- The completion plugin
    "hrsh7th/cmp-buffer", -- buffer completions
    "hrsh7th/cmp-path", -- path completions
    "saadparwaiz1/cmp_luasnip", -- snippet completions
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "zbirenbaum/copilot-cmp",
    "simrat39/rust-tools.nvim",

    -- snippets
    "L3MON4D3/LuaSnip", --snippet engine
    "rafamadriz/friendly-snippets", -- a bunch of snippets to use

    -- LSP
    "neovim/nvim-lspconfig", -- enable LSP
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
    "RRethy/vim-illuminate",

    -- Telescope
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -- Treesitter
    "nvim-treesitter/nvim-treesitter",

    -- Git
    "lewis6991/gitsigns.nvim",

    -- Docstring generator
    "danymat/neogen",

    -- Debugging (DAP)
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "ravenxrz/DAPInstall.nvim",
})

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

    -- Graphical user interface plugins
    "nvim-tree/nvim-web-devicons",
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
    "moll/vim-bbye", -- Manage buffers
    "nvim-lualine/lualine.nvim", -- Status line
    "goolord/alpha-nvim", -- Start-up page
    -- "christoomey/vim-tmux-navigator"

    -- Editing tools
    "ahmedkhalf/project.nvim",
    "akinsho/toggleterm.nvim",
    "mbbill/undotree",
    "windwp/nvim-autopairs", -- Autopairs, integrates with both cmp and treesitter
    "JoosepAlviste/nvim-ts-context-commentstring", -- Context-aware commenting
    { "numToStr/Comment.nvim", lazy = false },
    { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    "danymat/neogen", -- Docstring generator
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end,
    },
    -- LLMs
    "David-Kunz/gen.nvim",

    -- GitHub Copilot
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({})
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
    },

    -- Color schema_version
    "folke/tokyonight.nvim",
    "lunarvim/darkplus.nvim",

    -- Completion engine plugins
    "hrsh7th/nvim-cmp", -- The completion plugin
    "hrsh7th/cmp-buffer", -- buffer completions
    "hrsh7th/cmp-path", -- path completions
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "saadparwaiz1/cmp_luasnip", -- snippet completions
    "simrat39/rust-tools.nvim",

    -- Snippets
    "L3MON4D3/LuaSnip", --snippet engine
    "rafamadriz/friendly-snippets", -- a bunch of snippets to use

    -- Language servers
    "neovim/nvim-lspconfig", -- enable LSP
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
    "RRethy/vim-illuminate",

    -- Telescope
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
    },
    "nvim-treesitter/nvim-treesitter-context",

    -- Git
    "lewis6991/gitsigns.nvim",

    -- Debugging (DAP)
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "ravenxrz/DAPInstall.nvim",
})

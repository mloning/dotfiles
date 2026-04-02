return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      opt = {
        undofile = true, -- keep undo history on disk
      },
    },
    autocmds = {
      load_undotree = {
        {
          event = "VimEnter",
          desc = "Load built-in undotree",
          callback = function() vim.cmd "packadd nvim.undotree" end,
        },
      },
    },
    mappings = {
      n = { ["<Leader>u"] = { "<cmd>Undotree<cr>", desc = "Toggle Undo Tree" } },
    },
  },
}
